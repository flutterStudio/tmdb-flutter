import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GenreWidget extends StatelessWidget {
  final String genre;
  final Widget leading;
  GenreWidget(this.genre, {this.leading});
  @override
  Widget build(BuildContext context) => leading == null
      ? _body(context)
      : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.width *
                        Settings.FONT_SIZE_SMALL +
                    20,
                width: MediaQuery.of(context).size.width *
                        Settings.FONT_SIZE_SMALL +
                    10,
                child: leading),
            _body(context)
          ],
        );

  Widget _body(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Settings.COLOR_DARK_HIGHLIGHT,
          borderRadius: BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS)),
      padding: EdgeInsets.all(4),
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
