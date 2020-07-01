import 'dart:convert';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/service/tmdb_service.dart';

class MainRepository {
  static MainRepository _instance;

  factory MainRepository() =>
      _instance = _instance == null ? MainRepository._internal() : _instance;

  MainRepository._internal();

  Future<List<Movie>> getMovies({Map<String, dynamic> options}) async {
    List<Movie> movies = [];
    String rawResponse =
        await TmdbService().get(TmdbEndPoint.discoverMovies, options);
    var jsonResponse = jsonDecode(rawResponse) as Map;
    if ((jsonResponse['results'] as List).length > 0) {
      for (var rawMovie in jsonResponse['results'] as List) {
        movies.add(Movie.fromJson(rawMovie));
      }
    }
    return movies;
  }
}
