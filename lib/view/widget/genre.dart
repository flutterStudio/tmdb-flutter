import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Genre extends StatelessWidget {
  final String genre;
  Genre(this.genre);
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Settings.COLOR_DARK_HIGHLIGHT,
          borderRadius: BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS)),
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(2),
      child: Text(
        genre,
        softWrap: true,
        overflow: TextOverflow.clip,
        style: TextStyle(
            color: Settings.COLOR_DARK_TEXT,
            fontSize:
                MediaQuery.of(context).size.width * Settings.FONT_SIZE_SMALL,
            fontWeight: FontWeight.w300),
      ));
}
