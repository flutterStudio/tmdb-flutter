import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:TMDB_Mobile/common/settings.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc extends Bloc with ChangeNotifier {
  TmdbEndPoint tmdbEndPoint;
  String sortBy;
  double ratingLow;
  double ratinghigh;
  Map<Genre, bool> _tvGenres;
  Map<Genre, bool> _movieGenres;
  BehaviorSubject<Map<Genre, bool>> _tvGenresStreamController;
  BehaviorSubject<Map<Genre, bool>> _movieGenresStreamController;
  double runtimeLow;
  double runtimeHigh;
  int year;

  Stream<Map<Genre, bool>> get genresStream =>
      tmdbEndPoint == TmdbEndPoint.discoverTv
          ? _tvGenresStreamController.stream
          : tmdbEndPoint == TmdbEndPoint.discoverMovies
              ? _movieGenresStreamController.stream
              : null;

  SearchBloc() {
    tmdbEndPoint = TmdbEndPoint.discoverMovies;
    sortBy = "";
    ratingLow = Settings.MIN_RATING;
    ratinghigh = Settings.MAX_RATING;
    _tvGenres = {};
    _movieGenres = {};
    _initGenres();
    _tvGenresStreamController = BehaviorSubject<Map<Genre, bool>>();
    _movieGenresStreamController = BehaviorSubject<Map<Genre, bool>>();
    runtimeLow = Settings.MIN_MOVIE_RUNTIME;
    runtimeHigh = Settings.MAX_MOVIE_RUNTIME;
    year = Settings.MIN_YEAR;
  }

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
      notifyListeners();
    }
  }

  /// Returns search options as a Map of String, dynamic .
  Map<String, dynamic> applyFilter() {
    Map<String, dynamic> options = {};

    if (tmdbEndPoint == TmdbEndPoint.all) {
    } else {
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
        options["with_runtime.gte"] = year;
      }
    }
    return options;
  }

  /// Resets filter options to the defaults.
  void reset() {
    tmdbEndPoint = TmdbEndPoint.discoverMovies;
    sortBy = "";
    ratingLow = Settings.MIN_RATING;
    ratinghigh = Settings.MIN_RATING;
    runtimeLow = Settings.MIN_MOVIE_RUNTIME;
    runtimeHigh = Settings.MAX_MOVIE_RUNTIME;
    year = Settings.MIN_YEAR;
    notifyListeners();
  }

  @override
  void dispose() {
    _tvGenresStreamController.close();
    _movieGenresStreamController.close();
    super.dispose();
  }
}
