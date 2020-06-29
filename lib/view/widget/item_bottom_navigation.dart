import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnPressed = void Function();

class BottomNavigationItem extends StatelessWidget {
  final OnPressed onPressed;
  final IconData icon;
  final double size;
  final Color defaultColor;
  final Color activeColor;

  BottomNavigationItem({
    this.onPressed,
    this.icon,
    this.size,
    this.activeColor = Settings.COLOR_DARK_HIGHLIGHT,
    this.defaultColor = Settings.COLOR_DARK_SECONDARY,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          size: size,
          color: defaultColor,
        ),
      );
}
