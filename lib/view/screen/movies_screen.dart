import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/widget/movie_rating_rectangular.dart';
import 'package:TMDB_Mobile/view/widget/movies_slider_widget.dart';
import 'package:TMDB_Mobile/view/widget/screen_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: screenWidth * Settings.VERTICAL_SCREEN_PADDING),
      color: Settings.COLOR_DARK_PRIMARY,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "TMDB MOVIES",
            style: TextStyle(
                color: Settings.COLOR_DARK_TEXT,
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * Settings.FONT_SIZE_EXTRA_LARGE_FACTOR),
          ),
          ScreenSection(
            body: MoviesSlider(),
            onViewMore: null,
            title: "Upcoming",
          ),
          ScreenSection(
            horizontalPadding: screenWidth * Settings.VERTICAL_SCREEN_PADDING,
            body: Container(
                height: screenHeight * 0.5,
                child: ListView.builder(
                    itemExtent: screenWidth * 0.6,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: screenHeight * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.accents[index],
                                ),
                              ),
                              Text(
                                "Movie Name (Year)",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize:
                                        screenWidth * Settings.FONT_SIZE_MEDIUM,
                                    fontWeight: FontWeight.w300,
                                    color: Settings.COLOR_DARK_TEXT),
                              ),
                              MovieRatingRectangular(
                                text: "IMDB",
                                value: 7.0,
                              )
                            ])))),
            onViewMore: null,
            title: "Popular",
          )
        ],
      ),
    ));
  }
}
