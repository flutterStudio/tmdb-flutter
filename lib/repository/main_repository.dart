import 'dart:convert';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/model/tvshow_model.dart';
import 'package:TMDB_Mobile/service/tmdb_service.dart';
import 'package:TMDB_Mobile/utils/data.dart';

class MainRepository {
  static MainRepository _instance;
  List<Genre> _movieGenres;
  List<Genre> _tvGenres;

  // Cahce search results.
  // Holds lasr movies search results.
  Data<List<Movie>> _discoveredMovies;
  // Holds last Tv shows search results.
  Data<List<TvShow>> _discoveredTvShows;

  factory MainRepository() =>
      _instance = _instance == null ? MainRepository._internal() : _instance;

  MainRepository._internal() {
    _movieGenres = [];
    _tvGenres = [];

    _discoveredMovies = Data.empty(initialData: []);
    _discoveredTvShows = Data.empty(initialData: []);
  }

  /// Initialize Most needed data on boot.
  Future<void> initData() async {
    _movieGenres = await getGenres(endpoint: TmdbEndPoint.genreMovies);
    _tvGenres = await getGenres(endpoint: TmdbEndPoint.genreTv);
  }

  /// Fetches Movies from api with filters options.
  Future<Data<List<Movie>>> discoverMovies(
      {Map<String, dynamic> options,
      RequestType requestType = RequestType.fetch}) async {
    Data<List<Movie>> data = Data.loading(initialData: []);
    List<Movie> movies = [];
    try {
      String rawResponse =
          await TmdbService().get(TmdbEndPoint.discoverMovies, options);
      var jsonResponse = jsonDecode(rawResponse) as Map;
      if ((jsonResponse['results'] as List).length > 0) {
        for (var rawMovie in jsonResponse['results'] as List) {
          movies.add(Movie.fromJson(rawMovie));
        }
      }
      data = Data.complete(
          data: movies,
          message: "page ${jsonResponse["page"]}",
          page: jsonResponse["page"],
          totalPages: jsonResponse["total_pages"],
          totalResults: jsonResponse["total_results"]);
      _discoveredMovies.data.insertAll(0, data.data);
      _discoveredMovies.copyProperties(data);
    } catch (e) {
      data = Data.faild(
          previousData: _discoveredMovies.data, message: e.toString());
    }
    return data;
  }

  /// Fetches Tv shows from api with filters options.
  Future<Data<List<Movie>>> getMovies(TmdbEndPoint endpoint,
      {Map<String, dynamic> options,
      RequestType requestType = RequestType.fetch}) async {
    Data<List<Movie>> data = Data.loading(initialData: []);
    List<Movie> movies = [];
    try {
      String rawResponse = await TmdbService().get(endpoint, options);
      var jsonResponse = jsonDecode(rawResponse) as Map;
      if ((jsonResponse['results'] as List).length > 0) {
        for (var rawMovie in jsonResponse['results'] as List) {
          movies.add(Movie.fromJson(rawMovie));
        }
      }
      data = Data.complete(
          data: movies,
          page: jsonResponse["page"],
          totalPages: jsonResponse["total_pages"],
          totalResults: jsonResponse["total_results"]);
      _discoveredMovies.data.insertAll(0, data.data);
      _discoveredMovies.copyProperties(data);
    } catch (e) {
      data = Data.faild(
          previousData: _discoveredMovies.data, message: e.toString());
    }
    return data;
  }

  /// Fetches Tv shows from api with filters options.
  Future<Data<List<TvShow>>> getTvShows(TmdbEndPoint endpoint,
      {Map<String, dynamic> options,
      RequestType requestType = RequestType.fetch}) async {
    Data<List<TvShow>> data = Data.loading(initialData: []);
    List<TvShow> tvShows = [];
    try {
      String rawResponse = await TmdbService().get(endpoint, options);
      var jsonResponse = jsonDecode(rawResponse) as Map;
      if ((jsonResponse['results'] as List).length > 0) {
        for (var rawTvShow in jsonResponse['results'] as List) {
          tvShows.add(TvShow.fromJson(rawTvShow));
        }
      }

      data = Data.complete(
          data: tvShows,
          page: jsonResponse["page"],
          totalPages: jsonResponse["total_pages"],
          totalResults: jsonResponse["total_results"]);
      tvShows.length > 0 && requestType == RequestType.fetch
          ? _discoveredTvShows.data = tvShows
          : _discoveredTvShows.data.addAll(tvShows);

      _discoveredTvShows.copyProperties(data);
    } catch (e) {
      data = Data.faild(
          previousData: _discoveredTvShows.data, message: e.toString());
    }
    return data;
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
