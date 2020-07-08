import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ParentalGuide extends StatelessWidget {
  final bool adult;
  ParentalGuide({@required this.adult}) : assert(adult != null);
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
            color: adult ? Colors.redAccent : Settings.COLOR_DARK_HIGHLIGHT,
            borderRadius: BorderRadius.circular(3)),
        child: Text(
          adult ? "for adults" : "for all",
          style: TextStyle(
              color: Settings.COLOR_DARK_TEXT,
              fontWeight: FontWeight.w400,
              fontSize:
                  MediaQuery.of(context).size.width * Settings.FONT_SIZE_SMALL),
        ),
      );
}
