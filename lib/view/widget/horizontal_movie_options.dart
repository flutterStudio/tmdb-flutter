import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/widget/circular_rating_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalMovieOptionsPanel extends StatelessWidget {
  final AnimationController animationController;

  HorizontalMovieOptionsPanel(this.animationController);
  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color.fromRGBO(12, 37, 46, 0.8),
            borderRadius:
                BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircularRating(0.5, MediaQuery.of(context).size.width * 0.15,
                animationController),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Settings.COLOR_DARK_SECONDARY,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(
                Icons.turned_in,
                color: Settings.COLOR_DARK_SECONDARY,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: Settings.COLOR_DARK_SECONDARY,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
              onPressed: null,
            )
          ],
        ),
      );
}
