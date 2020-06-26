import 'dart:ui';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MoviesSlider extends StatefulWidget {
  @override
  _MoviesSliderState createState() => _MoviesSliderState();
}

class _MoviesSliderState extends State<MoviesSlider> {
  @override
  Widget build(BuildContext context) {
    double sliderHeight = MediaQuery.of(context).size.height * 0.35;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: sliderHeight,
      child: Swiper(
        pagination: SwiperPagination(),
        itemBuilder: (context, index) => Stack(children: <Widget>[
          Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/placeholders/trailer1.jpeg")),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(37, 112, 136, 0.9),
                    Color.fromRGBO(37, 112, 136, 0.2),
                    Colors.transparent
                  ],
                  begin: Alignment.centerLeft,
                  stops: [0, 0.7, 1],
                  end: Alignment.centerRight),
            ))
          ]),
          Positioned(
            height: sliderHeight * 0.5,
            left: sliderHeight * 0.05,
            bottom: sliderHeight * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Movie Name",
                  style: TextStyle(
                      fontSize: screenWidth * Settings.FONT_SIZE_MEDIUM,
                      fontWeight: FontWeight.w400,
                      color: Settings.COLOR_DARK_TEXT),
                ),
                Row(children: [
                  Container(
                    margin: EdgeInsets.only(right: sliderHeight * 0.04),
                    width: sliderHeight * 0.2,
                    height: sliderHeight * 0.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Settings.COLOR_DARK_PRIMARY),
                    child: Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              size: sliderHeight * 0.1,
                              color: Colors.white,
                            ),
                            onPressed: null)),
                  ),
                  Text(
                    "Watch Trailers",
                    style: TextStyle(
                        backgroundColor: Settings.COLOR_DARK_HIGHLIGHT,
                        fontSize: screenWidth * Settings.FONT_SIZE_SMALL,
                        fontWeight: FontWeight.w300,
                        color: Settings.COLOR_DARK_TEXT),
                  ),
                ])
              ],
            ),
          )
        ]),
        itemCount: 4,
      ),
    );
  }
}
