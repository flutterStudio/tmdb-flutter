import 'package:flutter/widgets.dart';

class Settings {
  // Dark theme colors.
  static const Color COLOR_DARK_PRIMARY = Color(0XFF0C252E);
  static const Color COLOR_DARK_SECONDARY = Color(0XFF09191F);
  static const Color COLOR_DARK_HIGHLIGHT = Color(0XFF257088);
  static const Color COLOR_DARK_SHADOW = Color(0XFF040F13);
  static const Color COLOR_DARK_TEXT = Color(0XFFFFFFFF);

  // Font size
  static const double FONT_SIZE_EXTRA_LARGE_FACTOR = 0.08;
  static const double FONT_SIZE_LARGE = 0.07;
  static const double FONT_SIZE_MEDIUM = 0.06;
  static const double FONT_SIZE_SMALL = 0.04;
  static const double FONT_SIZE_EXTRA_SMALL = 0.02;
  static const double FONT_SIZE_MICRO = 0.01;

  // Paddings factors
  static const double VERTICAL_SCREEN_PADDING = 0.05;
  static const double VERTICAL_SCREEN_SECTIONS_PADDING = 0.05;
  static const double HORIZONTAL_SCREEN_SECTIONS_PADDING = 0.05;

  // TMDB api settings.
  static const String TMDB_API_KEY = "aa49426d0fa8a9f0483b15a89d3657de";
  static const String TMDB_API_BASE_URL = "https://api.themoviedb.org/3/";

  // TMDB endpoints
  static const Map<TmdbEndPoint, String> TMDB_ENDPOINTS = {
    TmdbEndPoint.discoverMovies: "discover/movie",
    TmdbEndPoint.discoverTv: "discover/tv",
    TmdbEndPoint.genreMovies: "genre/movie/list",
    TmdbEndPoint.genreTv: "genre/tv/list",
  };

  // TMDB endpoint's options
  static const Map<String, List<String>> TMDB_SORT_OPTIONS = {
    "sort_by": [
      "popularity.asc",
      "popularity.desc",
      "release_date.as",
      "release_date.desc",
      "revenue.asc",
      "revenue.desc",
      "primary_release_date.asc",
      "primary_release_date.desc",
      "original_title.asc",
      "original_title.desc",
      "vote_average.asc",
      "vote_average.desc",
      "vote_count.asc",
      "vote_count.desc"
    ],
  };

  // HTTP request state common codes an their meaning.
  static const Map<int, String> HTTP_REQUEST_STATE_CODE = {
    200: "Ok",
    400: "BAD_REQUEST",
    401: "UNAUTHORIZED",
    403: "FORBIDDEN",
    404: "NOT_FOUND",
    408: "REQUEST_TIMEOUT",
  };
  // Border Radius
  static const double GENERAL_BORDER_RADIUS = 5;

  static const Widget VERTICAL_SCREEN_SPACER = SizedBox(
    height: VERTICAL_SCREEN_SECTIONS_PADDING,
    width: 10,
  );

  static const int MAX_YEAR = 3000;
  static const int MIN_YEAR = 0;

  static const double MAX_MOVIE_RUNTIME = 100;
  static const double MIN_MOVIE_RUNTIME = 0.0;

  static const double MAX_RATING = 10.0;
  static const double MIN_RATING = 0.0;

  static const int MAX_GENRES_PER_FILTER = 4;
}

/// TMDB endpoints
enum TmdbEndPoint { discoverMovies, discoverTv, genreMovies, genreTv, all }

/// TMDB Discover Options
