import 'dart:ui';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/view/screen/details_screen.dart';
import 'package:TMDB_Mobile/view/widget/hero_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MoviesSlider extends StatefulWidget {
  final List<Movie> _movies;
  MoviesSlider({@required movies})
      : _movies = movies,
        assert(movies != null && movies.length > 0);

  @override
  _MoviesSliderState createState() => _MoviesSliderState();
}

class _MoviesSliderState extends State<MoviesSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sliderHeight = MediaQuery.of(context).size.height * 0.3;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: sliderHeight,
      child: Swiper(
        loop: false,
        viewportFraction: 0.9,
        scale: 0.9,
        layout: SwiperLayout.DEFAULT,
        itemWidth: screenWidth * 0.8,
        itemHeight: sliderHeight * 0.9,
        pagination: new SwiperPagination(
            margin: EdgeInsets.all(0),
            builder: new SwiperCustomPagination(
                builder: (BuildContext context, SwiperPluginConfig config) {
              return new ConstrainedBox(
                child: new Container(
                    margin: EdgeInsets.only(top: sliderHeight * 0.3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                            4,
                            (index) => Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        index == config.activeIndex ? 10 : 2,
                                  ),
                                  width: 20,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: index == config.activeIndex
                                          ? Colors.accents[index]
                                          : Settings.COLOR_DARK_SECONDARY,
                                      borderRadius: BorderRadius.circular(5)),
                                )))),
                constraints: new BoxConstraints.expand(height: 60.0),
              );
            })),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsScreen.movie(
                        movie: widget._movies[index],
                        heroTag:
                            "${Settings.HERO_IMAGE_TAG}_MOVIE_UPCOMING_SLIDER_${widget._movies[index].id}",
                      )));
            },
            child: SizedBox.shrink(
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: sliderHeight * 0.9,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Settings.COLOR_DARK_SHADOW,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                                blurRadius: 10)
                          ]),
                          child: HeroNetworkImage(
                            tag:
                                "${Settings.HERO_IMAGE_TAG}_MOVIE_UPCOMING_SLIDER_${widget._movies[index].id}",
                            width: screenWidth,
                            height: sliderHeight * 0.9,
                            image:
                                "${Settings.TMDB_API_IMAGE_URL}w300${widget._movies[index].backdropPath}",
                          )),
                      Container(
                          height: sliderHeight * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Settings.GENERAL_BORDER_RADIUS),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.accents[index],
                                  Settings.COLOR_DARK_HIGHLIGHT.withOpacity(0),
                                ],
                                begin: Alignment.centerLeft,
                                stops: [0, 0.8],
                                end: Alignment.centerRight),
                          )),
                      Positioned(
                        height: sliderHeight * 0.5,
                        left: sliderHeight * 0.05,
                        bottom: sliderHeight * 0.02,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${widget._movies[index].title}",
                              style: TextStyle(
                                  fontSize:
                                      screenWidth * Settings.FONT_SIZE_MEDIUM,
                                  fontWeight: FontWeight.w500,
                                  color: Settings.COLOR_DARK_TEXT),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            )),
        itemCount: 4,
      ),
    );
  }
}
