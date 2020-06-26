import 'package:flutter/widgets.dart';

class Settings {
  // Dark theme colors.
  static const Color COLOR_DARK_PRIMARY = Color(0XFF0C252E);
  static const Color COLOR_DARK_SECONDARY = Color(0XFF09191F);
  static const Color COLOR_DARK_HIGHLIGHT = Color(0XFF257088);
  static const Color COLOR_DARK_SHADOW = Color(0XFF040F13);
  static const Color COLOR_DARK_TEXT = Color(0XFFFFFFFF);

  // Font Size
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

  static const Widget VERTICAL_SCREEN_SPACER = SizedBox(
    height: VERTICAL_SCREEN_SECTIONS_PADDING,
    width: 10,
  );
}
