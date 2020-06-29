import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/widget/item_movie_verical_view.dart';
import 'package:TMDB_Mobile/view/widget/movie_rating_rectangular.dart';
import 'package:TMDB_Mobile/view/widget/movies_slider_widget.dart';
import 'package:TMDB_Mobile/view/widget/screen_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        controller: controller,
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
                    fontSize:
                        screenWidth * Settings.FONT_SIZE_EXTRA_LARGE_FACTOR),
              ),
              ScreenSection(
                body: MoviesSlider(),
                onViewMore: null,
                title: "Upcoming",
              ),
              ScreenSection(
                horizontalPadding:
                    screenWidth * Settings.VERTICAL_SCREEN_PADDING,
                body: Container(
                    height: screenHeight * 0.5,
                    child: ListView.builder(
                        itemExtent: screenWidth * 0.6,
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            MovieVerticalView(index))),
                onViewMore: null,
                title: "Popular",
              ),
              ScreenSection(
                  title: "Trending",
                  horizontalPadding:
                      screenWidth * Settings.VERTICAL_SCREEN_PADDING,
                  background: Settings.COLOR_DARK_SECONDARY,
                  body: Container(
                      width: screenWidth,
                      height: screenHeight * 0.5,
                      child: GridView.builder(
                          itemCount: 6,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7, crossAxisCount: 3),
                          itemBuilder: (context, index) => Container(
                                width: screenWidth * 0.22,
                                height: screenHeight * 0.25,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.all(screenWidth * 0.02),
                                      decoration: BoxDecoration(
                                          color: Colors.accents[index],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    Positioned(
                                        bottom: screenHeight * 0.02,
                                        child: MovieRatingRectangular(
                                          text: "IMDB",
                                          value: 5.01,
                                        ))
                                  ],
                                ),
                              ))))
            ],
          ),
        ));
  }
}
