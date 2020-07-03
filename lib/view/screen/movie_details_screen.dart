import 'dart:ui';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/view/widget/actors_horizontal_list.dart';
import 'package:TMDB_Mobile/view/widget/genre_widget.dart';
import 'package:TMDB_Mobile/view/widget/horizontal_movie_options.dart';
import 'package:TMDB_Mobile/view/widget/item_movie_verical_view.dart';
import 'package:TMDB_Mobile/view/widget/parental_guide_.dart';
import 'package:TMDB_Mobile/view/widget/screen_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MovieDetailsScreen extends StatefulWidget {
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetailsScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
      upperBound: 1,
      lowerBound: 0,
    );
    _animationController.animateTo(0.2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                color: Settings.COLOR_DARK_PRIMARY,
                padding: EdgeInsets.symmetric(
                    vertical: screenWidth * Settings.VERTICAL_SCREEN_PADDING),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: screenHeight * 1.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/placeholders/poster.jpg"))),
                    ),
                    Container(
                        height: screenHeight * 1.4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Settings.COLOR_DARK_PRIMARY,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.9, 1]),
                        )),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            width: screenWidth,
                            color: Color.fromRGBO(12, 45, 53, 0.7),
                          ),
                        )),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight *
                                Settings.VERTICAL_SCREEN_SECTIONS_PADDING,
                          ),
                          Text(
                            "MOVIE NAME",
                            style: TextStyle(
                                color: Settings.COLOR_DARK_TEXT,
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth *
                                    Settings.FONT_SIZE_EXTRA_LARGE_FACTOR),
                          ),
                          SizedBox(
                            height: screenHeight *
                                Settings.VERTICAL_SCREEN_SECTIONS_PADDING,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  width: screenWidth * 0.4,
                                  height: screenHeight * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Settings.GENERAL_BORDER_RADIUS),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/placeholders/poster.jpg")),
                                  )),
                              Container(
                                  width: screenWidth * 0.5,
                                  height: screenHeight * 0.3,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.access_time,
                                                  size: screenWidth *
                                                      Settings.FONT_SIZE_MEDIUM,
                                                  color: Colors.white,
                                                )),
                                            Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "3h 15m",
                                                  style: TextStyle(
                                                      color: Settings
                                                          .COLOR_DARK_TEXT,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: screenWidth *
                                                          Settings
                                                              .FONT_SIZE_SMALL),
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ParentalGuide(age: 17),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.new_releases,
                                                  size: screenWidth *
                                                      Settings.FONT_SIZE_MEDIUM,
                                                  color: Colors.white,
                                                )),
                                            Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "09/20/2019 (US)",
                                                  style: TextStyle(
                                                      color: Settings
                                                          .COLOR_DARK_TEXT,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: screenWidth *
                                                          Settings
                                                              .FONT_SIZE_SMALL),
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          spacing: 2,
                                          runAlignment:
                                              WrapAlignment.spaceAround,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: <Widget>[
                                            GenreWidget(
                                                Genre(1, "Science Ficition")),
                                          ],
                                        ),
                                        Expanded(child: Container())
                                      ])),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight *
                                Settings.VERTICAL_SCREEN_SECTIONS_PADDING,
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenHeight * 0.01),
                            child: HorizontalMovieOptionsPanel(
                                _animationController),
                          ),
                          ScreenSection(
                            background: Colors.transparent,
                            title: "Overview",
                            body: Text(
                              "The near future, a time when both hope and hardships drive humanity to look to the stars and beyond. While a mysterious phenomenon menaces to destroy life on planet Earth, astronaut Roy McBride undertakes a mission across the immensity of space and its many perils to uncover the truth about a lost expedition that decades before boldly faced emptiness and silence in search of the unknown.",
                              style: TextStyle(
                                  color: Settings.COLOR_DARK_TEXT,
                                  fontWeight: FontWeight.w300,
                                  fontSize:
                                      screenWidth * Settings.FONT_SIZE_SMALL),
                            ),
                          ),
                          ScreenSection(
                            background: Colors.transparent,
                            title: "Cast",
                            onViewMore: () {},
                            body: ActorsHorizontalLs(screenWidth * 0.25),
                          ),
                          ScreenSection(
                            background: Colors.transparent,
                            body: Container(
                                height: screenHeight * 0.5,
                                child: ListView.builder(
                                    itemExtent: screenWidth * 0.6,
                                    itemCount: 4,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        MovieVerticalView(index))),
                            onViewMore: null,
                            title: "More Like This",
                          ),
                        ]),
                  ],
                ))));
  }
}
