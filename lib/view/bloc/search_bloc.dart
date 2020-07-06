import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/model/tvshow_model.dart';
import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:TMDB_Mobile/common/settings.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc extends Bloc with ChangeNotifier {
  TmdbEndPoint tmdbEndPoint;
  String sortBy;
  double ratingLow;
  double ratinghigh;
  // Ssearch query.
  String query;
  // If true, search field will be disables,
  // but you will have more filter options.
  bool searchEnabled;
  int page;
  Map<Genre, bool> _tvGenres;
  Map<Genre, bool> _movieGenres;

  // Discovered movies.
  List<Movie> discoveredMovies;
  // Discovered tv shows.
  List<TvShow> discoveredTvShows;

  // movies search result.
  List<Movie> moviesSearchResult;
  // tv shows search result.
  List<TvShow> tvShowsSrearchResult;

  BehaviorSubject<Map<Genre, bool>> _tvGenresStreamController;
  BehaviorSubject<Map<Genre, bool>> _movieGenresStreamController;
  BehaviorSubject<Data<List<Movie>>> _discoverMovieStreamController;
  BehaviorSubject<Data<List<TvShow>>> _discoverTvShowStreamController;

  BehaviorSubject<Data<List<Movie>>> _searchMovieStreamController;
  BehaviorSubject<Data<List<TvShow>>> _searchTvShowStreamController;

  BehaviorSubject<dynamic> _searchStreamController;

  double runtimeLow;
  double runtimeHigh;
  int year;

  SearchBloc() {
    tmdbEndPoint = TmdbEndPoint.discoverMovies;
    sortBy = "";
    page = 0;
    query = "";
    ratingLow = Settings.MIN_RATING;
    ratinghigh = Settings.MAX_RATING;
    _tvGenres = {};
    _movieGenres = {};

    discoveredMovies = [];
    discoveredTvShows = [];

    moviesSearchResult = [];
    tvShowsSrearchResult = [];

    _initGenres();
    _tvGenresStreamController = BehaviorSubject<Map<Genre, bool>>();
    _movieGenresStreamController = BehaviorSubject<Map<Genre, bool>>();

    _discoverMovieStreamController = BehaviorSubject<Data<List<Movie>>>();
    _discoverTvShowStreamController = BehaviorSubject<Data<List<TvShow>>>();

    _searchMovieStreamController = BehaviorSubject<Data<List<Movie>>>();
    _searchTvShowStreamController = BehaviorSubject<Data<List<TvShow>>>();

    _searchStreamController = BehaviorSubject<dynamic>();

    runtimeLow = Settings.MIN_MOVIE_RUNTIME;
    runtimeHigh = Settings.MAX_MOVIE_RUNTIME;
    year = Settings.MIN_YEAR;
    searchEnabled = false;
  }

  Stream<Map<Genre, bool>> get genresStream =>
      tmdbEndPoint == TmdbEndPoint.discoverTv
          ? _tvGenresStreamController.stream
          : tmdbEndPoint == TmdbEndPoint.discoverMovies
              ? _movieGenresStreamController.stream
              : null;

  Stream<dynamic> get searchStreams =>
      tmdbEndPoint == TmdbEndPoint.discoverMovies
          ? _discoverMovieStreamController.stream
          : tmdbEndPoint == TmdbEndPoint.searchMovies
              ? _searchMovieStreamController.stream
              : tmdbEndPoint == TmdbEndPoint.discoverTv
                  ? _discoverTvShowStreamController.stream
                  : _searchTvShowStreamController;

  /// Updates [sortBy] value in [SearchBloc] and updates ui listeners.
  void changeSortBy(String sortByValue) {
    sortBy = sortByValue;
    notifyListeners();
  }

  /// Updates either [_tvGenres] or [_movieGenres] depending on the current [tmdbEndPoint],
  ///  and updates streams.
  void updateGenre(Genre genre, bool value) {
    switch (tmdbEndPoint) {
      case TmdbEndPoint.discoverTv:
        {
          _tvGenres[genre] = value;
          _tvGenresStreamController.sink.add(_tvGenres);

          break;
        }

      case TmdbEndPoint.discoverMovies:
        {
          _movieGenres[genre] = value;
          _movieGenresStreamController.sink.add(_movieGenres);

          break;
        }
      default:
        {
          return;
        }
    }
    notifyListeners();
  }

  /// Retrives geners from MainRepository class.
  /// This method should be called only in the constructor,
  ///  or when using [reset] method.
  Future<void> _initGenres() async {
    var tvGenres = [];
    tvGenres = await MainRepository().getGenres(endpoint: TmdbEndPoint.genreTv);
    _tvGenres = Map.fromIterable(tvGenres,
        key: (genre) => genre, value: (genre) => false);
    _tvGenresStreamController.sink.add(_tvGenres);

    var movieGenres = [];
    movieGenres =
        await MainRepository().getGenres(endpoint: TmdbEndPoint.genreMovies);
    _movieGenres = Map.fromIterable(movieGenres,
        key: (genre) => genre, value: (genre) => false);

    _tvGenresStreamController.sink.add(_movieGenres);
  }

  /// Updates genres streams according to [tmdbEndPoint].
  Future<void> getGenres() async {
    switch (tmdbEndPoint) {
      case TmdbEndPoint.discoverTv:
        {
          if (_tvGenres.length == 0) {
            _initGenres();
          }
          _tvGenresStreamController.sink.add(_tvGenres);
          break;
        }

      case TmdbEndPoint.discoverMovies:
        {
          if (_movieGenres.length == 0) {
            _initGenres();
          }
          _movieGenresStreamController.sink.add(_movieGenres);
          break;
        }
      default:
        {}
    }
  }

  /// Updates rating values [ratingLow] and [ratingHigh] in [SearchBloc] and,
  /// notifys ui listeners.
  void updateRating(double lowerValue, double higherValue) {
    if (lowerValue.floorToDouble() != null) {
      ratingLow = lowerValue.floorToDouble();
    }
    if (higherValue.ceilToDouble() != null) {
      ratinghigh = higherValue.floorToDouble();
    }
    notifyListeners();
  }

  /// Updates runtime values [runtimeLow] and [runtimeHigh] in [SearchBloc] and,
  /// notifys ui listeners.
  void updateRunTime(double lowerValue, double higherValue) {
    if (lowerValue.floorToDouble() != null) {
      runtimeLow = lowerValue.floorToDouble();
    }
    if (higherValue.floorToDouble() != null) {
      runtimeHigh = higherValue.floorToDouble();
    }
    notifyListeners();
  }

  void updateYear(int yearvalue) {
    if (yearvalue != null) {
      year = yearvalue;
    }
  }

  void updateEndPoint(TmdbEndPoint endpoint) {
    if (tmdbEndPoint != endpoint) {
      tmdbEndPoint = endpoint;
      if (tmdbEndPoint == TmdbEndPoint.searchTv ||
          tmdbEndPoint == TmdbEndPoint.searchMovies) {
        searchEnabled = true;
      } else {
        searchEnabled = false;
      }
      notifyListeners();
    }
  }

  /// Update query text [value].
  void updateQuery(String value) {
    query = value;

    if (value.isNotEmpty) {
      searchEnabled = true;
    } else {
      searchEnabled = false;
    }
  }

  /// Returns search options as a Map of String, dynamic .
  Map<String, dynamic> applyFilter() {
    Map<String, dynamic> options = {};
    options["include_adult"] = true;
    if (searchEnabled) {
      if (query.isNotEmpty) {
        options["query"] = query;
      }
      if (year > Settings.MIN_YEAR) {
        options[tmdbEndPoint == TmdbEndPoint.discoverMovies
            ? "primary_release_year"
            : "first_air_date_year"] = year;
      }

      if (tmdbEndPoint == TmdbEndPoint.discoverMovies) {
        tmdbEndPoint = TmdbEndPoint.searchMovies;
        searchEnabled = true;
      }
      if (tmdbEndPoint == TmdbEndPoint.discoverTv) {
        tmdbEndPoint = TmdbEndPoint.searchTv;
      }
    } else {
      if (tmdbEndPoint == TmdbEndPoint.searchMovies) {
        tmdbEndPoint = TmdbEndPoint.discoverMovies;
      }
      if (tmdbEndPoint == TmdbEndPoint.searchTv) {
        tmdbEndPoint = TmdbEndPoint.discoverTv;
      }
      if (sortBy.isNotEmpty) {
        options["sort_by"] = sortBy;
      }
      // Add rating bounds
      if (ratingLow > Settings.MIN_RATING) {
        options["vote_average.gte"] = ratingLow;
      }
      if (ratinghigh < Settings.MAX_RATING) {
        options["vote_average.lte"] = ratinghigh;
      }
      // Add runtime bounds
      if (runtimeLow > Settings.MIN_MOVIE_RUNTIME) {
        options["with_runtime.gte"] = ratingLow;
      }
      if (runtimeHigh < Settings.MAX_MOVIE_RUNTIME) {
        options["with_runtime.lte"] = ratinghigh;
      }
      // Add year value.
      if (year > Settings.MIN_YEAR) {
        options[tmdbEndPoint == TmdbEndPoint.discoverMovies
            ? "primary_release_year"
            : "first_air_date_year"] = year;
      }
      if (tmdbEndPoint == TmdbEndPoint.discoverMovies) {
        List<int> genres = [];
        _movieGenres.forEach((key, value) {
          if (value) {
            genres.add(key.id);
          }
        });
        if (genres.length > 0) {
          options["with_genres"] = genres;
        }
      }
      if (tmdbEndPoint == TmdbEndPoint.discoverTv) {
        List<int> genres = [];
        _tvGenres.forEach((key, value) {
          if (value) {
            genres.add(key.id);
          }
        });
        if (genres.length > 0) {
          options["with_genres"] = genres;
        }
      }
    }
    notifyListeners();
    return options;
  }

  /// Resets filter options to the defaults.
  void reset() {
    tmdbEndPoint = TmdbEndPoint.discoverMovies;
    sortBy = "";
    ratingLow = Settings.MIN_RATING;
    ratinghigh = Settings.MAX_RATING;
    runtimeLow = Settings.MIN_MOVIE_RUNTIME;
    runtimeHigh = Settings.MAX_MOVIE_RUNTIME;
    year = Settings.MIN_YEAR;
    notifyListeners();
  }

  /// Gets movies list.
  Future<void> search(
    RequestType requestType,
  ) async {
    var options = applyFilter();
    if (requestType == RequestType.fetchMore) {
      options["page"] = page + 1;
    }
    switch (tmdbEndPoint) {
      case TmdbEndPoint.discoverMovies:
        {
          if (requestType == RequestType.fetch) {
            _discoverMovieStreamController.sink
                .add(Data<List<Movie>>.loading());
          }

          var data = await MainRepository().getMovies(tmdbEndPoint,
              options: options, requestType: requestType);
          requestType == RequestType.fetch && data.status == DataStatus.complete
              ? discoveredMovies = data.data
              : discoveredMovies.addAll(data.data);
          page = data.page;
          data.data = discoveredMovies;

          _discoverMovieStreamController.sink.add(data);

          break;
        }
      case TmdbEndPoint.searchMovies:
        {
          if (requestType == RequestType.fetch) {
            _searchMovieStreamController.sink.add(Data<List<Movie>>.loading());
          }

          var data = await MainRepository().getMovies(tmdbEndPoint,
              options: options, requestType: requestType);
          requestType == RequestType.fetch && data.status == DataStatus.complete
              ? moviesSearchResult = data.data
              : moviesSearchResult.addAll(data.data);
          page = data.page;
          data.data = moviesSearchResult;

          _searchMovieStreamController.sink.add(data);
          notifyListeners();
          break;
        }
      case TmdbEndPoint.discoverTv:
        {
          if (requestType == RequestType.fetch) {
            _discoverTvShowStreamController.sink
                .add(Data<List<TvShow>>.loading());
          }
          var data = await MainRepository().getTvShows(tmdbEndPoint,
              options: options, requestType: requestType);
          requestType == RequestType.fetch
              ? discoveredTvShows = data.data
              : discoveredTvShows.addAll(data.data);
          // current page
          page = data.page;
          data.data = discoveredTvShows;
          _discoverTvShowStreamController.add(data);
          break;
        }
      case TmdbEndPoint.searchTv:
        {
          if (requestType == RequestType.fetch) {
            _searchTvShowStreamController.sink
                .add(Data<List<TvShow>>.loading());
          }
          var data = await MainRepository().getTvShows(tmdbEndPoint,
              options: options, requestType: requestType);
          requestType == RequestType.fetch
              ? tvShowsSrearchResult = data.data
              : tvShowsSrearchResult.addAll(data.data);
          // current page
          page = data.page;
          data.data = tvShowsSrearchResult;
          _searchTvShowStreamController.add(data);
          notifyListeners();
          break;
        }

      default:
    }
  }

  @override
  void dispose() {
    _tvGenresStreamController.close();
    _movieGenresStreamController.close();
    _discoverMovieStreamController.close();
    _discoverTvShowStreamController.close();
    _searchStreamController.close();

    _searchMovieStreamController.close();
    _searchTvShowStreamController.close();
    super.dispose();
  }
}
