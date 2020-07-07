import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef OnPressed = void Function();

class BottomNavigationItem extends StatelessWidget {
  final OnPressed onPressed;
  final IconData icon;
  final double size;
  final int index;
  final Color defaultColor;
  final Color activeColor;

  BottomNavigationItem({
    @required this.index,
    this.onPressed,
    this.icon,
    this.size,
    this.activeColor = Settings.COLOR_DARK_HIGHLIGHT,
    this.defaultColor = Settings.COLOR_DARK_SHADOW,
  }) : assert(index != null);
  @override
  Widget build(BuildContext context) => IconButton(
        icon: Consumer<MainBloc>(
            builder: (context, mainBloc, child) => AnimatedContainer(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeInOutCubic,
                child: Icon(
                  icon,
                  size: size,
                  color: mainBloc.currentPage == index
                      ? activeColor
                      : defaultColor,
                ))),
        onPressed: onPressed,
      );
}
