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
}

/// TMDB endpoints
enum TmdbEndPoint { discoverMovies, discoverTv }
