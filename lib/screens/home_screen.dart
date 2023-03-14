import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/movie_model.dart';
import 'package:movies_app/providers/providers.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var _connectivityStatus = 'Unknown';
  String movie = '';
  late SharedPreferences preferences;
  late Movie movies;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          _connectivityStatus = 'Connected';
        });
      } else {
        setState(() {
          _connectivityStatus = 'Disconnected';
        });
      }
    });
  }

  Future init() async{
    preferences = await SharedPreferences.getInstance();

    final movieJson = preferences.getString('movies');
    if (movieJson == null)return;

    final movies = Movie.fromJson(jsonDecode(movieJson));
    setState(() {
      this.movies = movies;
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _connectivityStatus = 'Connected';
      });
    } else {
      setState(() {
        _connectivityStatus = 'Disconnected';
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(_connectivityStatus == 'Connected'? Icons.network_wifi: Icons.perm_scan_wifi_outlined),
        title: IconButton(
          onPressed: () async {
             final movieJson =jsonEncode(movies.toJson());
             preferences.setString('movies', movieJson);
          },
          icon: const Icon(Icons.sync),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MovieSearchDelegate());
              },
              icon: const Icon(Icons.search_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Main cards
            CardSwiperWidget(
              movies: moviesProvider.onDisplayMovies,
            ),
            // movies horizontal list
            MovieSliderWidget(
                movies: moviesProvider.popularMovies,
                title: 'Popular Movies',
                onNextPage: () => moviesProvider.getPopularMovies()),
          ],
        ),
      ),
    );
  }
}

