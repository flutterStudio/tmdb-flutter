import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/screen/movie_details_screen.dart';
import 'package:TMDB_Mobile/view/widget/movie_rating_rectangular.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieVerticalView extends StatelessWidget {
  final int id;
  MovieVerticalView(this.id);
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MovieDetails())),
                  child: Container(
                    height: screenHeight * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.accents[id],
                    ),
                  )),
              Text(
                "Movie Name (Year)",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: screenWidth * Settings.FONT_SIZE_MEDIUM,
                    fontWeight: FontWeight.w300,
                    color: Settings.COLOR_DARK_TEXT),
              ),
              MovieRatingRectangular(
                text: "IMDB",
                value: 7.0,
              )
            ]));
  }
}
