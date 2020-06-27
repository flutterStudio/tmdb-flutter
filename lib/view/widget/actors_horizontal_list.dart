import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActorsHorizontalLs extends StatelessWidget {
  final double size;
  ActorsHorizontalLs(this.size) : assert(size != null);
  @override
  Widget build(BuildContext context) => SizedBox(
      height: size,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(right: size * 0.1),
                width: size,
                height: size,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: size * 0.05,
                        color: Settings.COLOR_DARK_HIGHLIGHT),
                    color: Colors.accents[index]),
              )));
}
