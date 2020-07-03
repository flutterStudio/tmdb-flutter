import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/widgets.dart';

class MovieRatingRectangular extends StatelessWidget {
  final String text;
  final double value;
  MovieRatingRectangular({this.text, this.value})
      : assert(text.isNotEmpty),
        assert(value != null);
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS),
            color: Settings.COLOR_DARK_HIGHLIGHT),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  color: Settings.COLOR_DARK_TEXT,
                  fontSize: MediaQuery.of(context).size.width *
                      Settings.FONT_SIZE_SMALL,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                  color: Settings.COLOR_DARK_TEXT,
                  fontSize: MediaQuery.of(context).size.width *
                      Settings.FONT_SIZE_SMALL,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      );
}
