import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/helpers.dart';
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = '76d4f9910fda2c5e68906baf65b3b6c1';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'en-US';

  List<Movie> onDisplayMovies= [];
  List<Movie> popularMovies= [];
  int _popularPage = 0;

  Map<int, List<Cast>> movieCast = {};

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionsStreamController = StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => _suggestionsStreamController.stream;

  MoviesProvider(){
    print('MoviesProvider has been initialized');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String>_getJsonData(String endpoint, [int page = 1])async{
    final url = Uri.https( _baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page' 
    } );
    //await the http get response, then decode the json-formatted response
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData(
      '3/movie/popular', 
      _popularPage
    );
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [ ...popularMovies, ...popularResponse.results ];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;
    //TODO: review Map
    print('getting info from server - Cast');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    movieCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {

     final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });
    final response = await http.get(url);
    final searchResponse = SearchMovieResponse.fromJson(response.body);

    return searchResponse.results; 
  }

  void getSuggestionsByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovie(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) { 
        debouncer.value = searchTerm; 
      }
    );
    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

     

}