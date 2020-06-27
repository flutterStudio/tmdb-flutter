import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ParentalGuide extends StatelessWidget {
  final int age;
  ParentalGuide({@required this.age}) : assert(age != null);
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(3)),
        child: Text(
          "PG-$age",
          style: TextStyle(
              color: Settings.COLOR_DARK_TEXT,
              fontWeight: FontWeight.w400,
              fontSize:
                  MediaQuery.of(context).size.width * Settings.FONT_SIZE_SMALL),
        ),
      );
}
