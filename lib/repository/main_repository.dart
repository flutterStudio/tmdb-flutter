import 'dart:convert';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/MovieDetails.dart';
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
  Data<List<Movie>> _searchScreenMovies;
  // Holds last Tv shows search results.
  Data<List<TvShow>> _searchScreenTvShows;

  List<MovieDetails> _movies;

  Data<List<Movie>> _trendingMovies;

  Data<List<Movie>> _popularMovies;

  Data<List<Movie>> _topRatedMovies;

  Data<List<Movie>> _nowPlayingMovies;

  Data<List<Movie>> _latestMovies;

  Data<List<Movie>> _upcomingMovies;

  Map<TmdbEndPoint, dynamic> _cachedData;

  factory MainRepository() =>
      _instance = _instance == null ? MainRepository._internal() : _instance;

  MainRepository._internal() {
    _movieGenres = [];
    _tvGenres = [];

    _searchScreenMovies = Data.empty(initialData: []);
    _searchScreenTvShows = Data.empty(initialData: []);

    _movies = [];

    _trendingMovies = Data.empty(initialData: []);
    _popularMovies = Data.empty(initialData: []);
    _topRatedMovies = Data.empty(initialData: []);
    _nowPlayingMovies = Data.empty(initialData: []);
    _latestMovies = Data.empty(initialData: []);
    _upcomingMovies = Data.empty(initialData: []);

    _cachedData = {
      TmdbEndPoint.movieLatest: _latestMovies,
      TmdbEndPoint.movieNowPlaying: _nowPlayingMovies,
      TmdbEndPoint.movieUpcoming: _upcomingMovies,
      TmdbEndPoint.movieTopRated: _topRatedMovies,
      TmdbEndPoint.moviePopular: _popularMovies,
      TmdbEndPoint.discoverMovies: _searchScreenMovies,
      TmdbEndPoint.searchMovies: _searchScreenMovies,
      TmdbEndPoint.movie: _movies,
      TmdbEndPoint.discoverTv: _searchScreenTvShows,
      TmdbEndPoint.searchTv: _searchScreenTvShows,
    };
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
      _searchScreenMovies.data.insertAll(0, data.data);
      _searchScreenMovies.copyProperties(data);
    } catch (e) {
      data = Data.faild(
          previousData: _searchScreenMovies.data, message: e.toString());
    }
    return data;
  }

  /// Fetches Tv shows from api with filters options.
  Future<Data<List<Movie>>> getMovies(TmdbEndPoint endpoint,
      {Map<String, dynamic> options,
      RequestType requestType = RequestType.fetch,
      bool trending = false}) async {
    Data<List<Movie>> data = Data.loading(initialData: []);
    List<Movie> movies = [];
    try {
      String rawResponse =
          await TmdbService().get(endpoint, options, trending: trending);
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
      if (!trending) {
        _cachedData[endpoint].data.insertAll(0, data.data);
        _cachedData[endpoint].copyProperties(data);
      } else {
        _trendingMovies.data.insertAll(0, data.data);
        _cachedData[endpoint].copyProperties(data);
      }
    } catch (e) {
      data = Data.faild(
          previousData: _cachedData[endpoint].data, message: e.toString());
    }
    return data;
  }

  /// Fetches Tv shows from api with filters options.
  Future<Data<List<TvShow>>> getTvShows(TmdbEndPoint endpoint,
      {Map<String, dynamic> options,
      RequestType requestType = RequestType.fetch,
      bool trending = false}) async {
    Data<List<TvShow>> data = Data.loading(initialData: []);
    List<TvShow> tvShows = [];
    try {
      String rawResponse =
          await TmdbService().get(endpoint, options, trending: trending);
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
          ? _cachedData[endpoint].data = tvShows
          : _cachedData[endpoint].data.addAll(tvShows);

      _cachedData[endpoint].copyProperties(data);
    } catch (e) {
      data = Data.faild(
          previousData: _cachedData[endpoint].data, message: e.toString());
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

  /// Get Details of the movie with the following [id].,
  Future<Data<MovieDetails>> getMovieDetails(int id) async {
    Data<MovieDetails> data = Data.loading(initialData: MovieDetails());
    MovieDetails movie =
        _movies.firstWhere((element) => element.id == id, orElse: () => null);
    if (movie != null) {
      return Data.complete(data: movie);
    }
    try {
      String rawResponse = await TmdbService().get(
        TmdbEndPoint.movie,
        {"id": id},
      );
      var jsonResponse = jsonDecode(rawResponse) as Map;
      if (jsonResponse != null) {
        movie = MovieDetails.fromJson(jsonResponse);
        _movies.add(movie);
        data = Data.complete(
          data: movie,
        );
      }
    } catch (e) {
      data = Data.faild(message: e.toString());
    }
    return data;
  }
}
