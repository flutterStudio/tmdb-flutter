import 'dart:convert';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/service/tmdb_service.dart';

class MainRepository {
  static MainRepository _instance;
  List<Genre> _movieGenres;
  List<Genre> _tvGenres;

  factory MainRepository() =>
      _instance = _instance == null ? MainRepository._internal() : _instance;

  MainRepository._internal() {
    _movieGenres = [];
    _tvGenres = [];
  }

  /// Initialize Most needed data on boot.
  Future<void> initData() async {
    _movieGenres = await getGenres(endpoint: TmdbEndPoint.genreMovies);
    _tvGenres = await getGenres(endpoint: TmdbEndPoint.genreTv);
  }

  /// Fetches Movies from api with filters options.
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

  /// Fetches Genres from api with filters options.
  Future<List<Genre>> getGenres(
      {Map<String, dynamic> options, TmdbEndPoint endpoint}) async {
    if (endpoint == TmdbEndPoint.genreMovies) {
      if (_movieGenres.length > 0) {
        return _movieGenres;
      }
    } else {
      if (_tvGenres.length > 0) {
        return _tvGenres;
      }
    }
    List<Genre> genres = [];
    String rawResponse = await TmdbService().get(endpoint, options);
    var jsonResponse = jsonDecode(rawResponse) as Map;
    if ((jsonResponse['genres'] as List).length > 0) {
      for (var rawGenre in jsonResponse['genres'] as List) {
        genres.add(Genre.fromJson(rawGenre));
      }
    }
    return genres;
  }
}
