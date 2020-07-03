import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:TMDB_Mobile/common/settings.dart';

class SearchBloc extends Bloc with ChangeNotifier {
  TmdbEndPoint tmdbEndPoint;
  String sortBy;
  double ratingLow;
  double ratinghigh;
  List<Genre> genres;
  double runtimeLow;
  double runtimeHigh;
  int year;

  SearchBloc() {
    tmdbEndPoint = TmdbEndPoint.discoverMovies;
    sortBy = "";
    ratingLow = Settings.MIN_RATING;
    ratinghigh = Settings.MAX_RATING;
    genres = [
      Genre(1, "Science Fiction"),
      Genre(2, "Drama"),
      Genre(3, "Horor"),
      Genre(1, "Crime")
    ];
    runtimeLow = Settings.MIN_MOVIE_RUNTIME;
    runtimeHigh = Settings.MAX_MOVIE_RUNTIME;
    year = Settings.MIN_YEAR;
  }

  void addGenre(int id) {
    // Get genres from main repository.
    // check if it is already in genres list.
    // if it snot add.
    notifyListeners();
  }

  void removeGenre(int id) {
    // check if it exists in the genres list.
    // if so delete it.
    notifyListeners();
  }

  List<Genre> availableGenres() {
    List<Genre> genresList = [];
    //TODO: get genres from main repo.
    //TODO: remove duplicates ones with genres list.
    return genres;
  }

  void updateRating(double lowerValue, double higherValue) {
    if (lowerValue.floorToDouble() != null) {
      ratingLow = lowerValue;
    }
    if (higherValue.ceilToDouble() != null) {
      ratinghigh = higherValue;
    }
    notifyListeners();
  }

  void updateRunTime(double lowerValue, double higherValue) {
    if (lowerValue != null) {
      ratingLow = lowerValue;
    }
    if (higherValue != null) {
      ratingLow = lowerValue;
    }
    // notifyListeners();
  }

  void updateYear(int yearvalue) {
    if (yearvalue != null) {
      year = yearvalue;
    }

    // notifyListeners();
  }

  void updateEndPoint(TmdbEndPoint endpoint) {
    if (tmdbEndPoint != endpoint) {
      tmdbEndPoint = endpoint;
      notifyListeners();
    }
  }

  Future<void> applyFilter() async {
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
  }

  void reset() {
    tmdbEndPoint = TmdbEndPoint.discoverMovies;
    sortBy = "";
    ratingLow = Settings.MIN_RATING;
    ratinghigh = Settings.MIN_RATING;
    genres = [];
    runtimeLow = Settings.MIN_MOVIE_RUNTIME;
    runtimeHigh = Settings.MAX_MOVIE_RUNTIME;
    year = Settings.MIN_YEAR;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
