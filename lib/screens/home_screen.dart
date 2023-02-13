

import 'package:flutter/material.dart';
import 'package:movies_app/providers/providers.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies in cinema'),
        actions: [ 
          IconButton(
            onPressed: (){
              showSearch(
                context: context,
                delegate: MovieSearchDelegate()
              );
            },
            icon: const Icon (Icons.search_outlined)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Main cards
            CardSwiperWidget(
             movies:  moviesProvider.onDisplayMovies,
            ),
            // movies horizontal list
             MovieSliderWidget(
              movies: moviesProvider.popularMovies,
              title: 'Popular Movies',
              onNextPage: () => moviesProvider.getPopularMovies()
            ),
          ],
        ),
      ),
    );
  }
}