import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/movies_screen_bloc.dart';
import 'package:TMDB_Mobile/view/screen/details_screen.dart';
import 'package:TMDB_Mobile/view/widget/item_verical_view.dart';
import 'package:TMDB_Mobile/view/widget/movie_rating_rectangular.dart';
import 'package:TMDB_Mobile/view/widget/movies_slider_widget.dart';
import 'package:TMDB_Mobile/view/widget/screen_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  ScrollController controller;
  MoviesScreenBloc _moviesScreenBloc;
  @override
  void initState() {
    controller = ScrollController();
    // controller.addListener(() {
    //   // Listen to scrolling events
    //   // If the user is scrolling down then hide the bottom navigation
    //   // if (controller.position.userScrollDirection == ScrollDirection.forward) {
    //   //   if (!_mainBloc.isBottomNavigationUp) {
    //   //     _mainBloc.showBottomNavigation();
    //   //   }
    //   //   // If the user is scrolling up then shpw the bottom navigation

    //   // } else {
    //   //   if (_mainBloc.isBottomNavigationUp) {
    //   //     _mainBloc.hideBottomNavigation();
    //   //   }
    //   // }
    // });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _moviesScreenBloc.getUpcoming();
      _moviesScreenBloc.getPopular();
      _moviesScreenBloc.getTrending();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _moviesScreenBloc = Provider.of<MoviesScreenBloc>(context);

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
                body: StreamBuilder<Data<List<Movie>>>(
                    stream: _moviesScreenBloc.upcomingMoviesStream,
                    builder: (context, snapshot) {
                      Widget widget = Center(
                          child: SpinKitCubeGrid(
                        color: Settings.COLOR_DARK_HIGHLIGHT,
                      ));
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case DataStatus.faild:
                            {
                              widget = Center(
                                child: Text("Error Loading upcoming Movies"),
                              );
                              break;
                            }
                          case DataStatus.complete:
                            {
                              widget = snapshot.data.data.length > 0
                                  ? MoviesSlider(
                                      movies: snapshot.data.data,
                                    )
                                  : Center(
                                      child: Text("Empty Response"),
                                    );
                              break;
                            }
                          default:
                        }
                      }
                      return widget;
                    }),
                onViewMore: null,
                title: "Upcoming",
              ),
              ScreenSection(
                horizontalPadding:
                    screenWidth * Settings.VERTICAL_SCREEN_PADDING,
                body: Container(
                    height: screenHeight * 0.5,
                    child: StreamBuilder<Data<List<Movie>>>(
                        stream: _moviesScreenBloc.popularMoviesStream,
                        builder: (context, snapshot) {
                          Widget widget = Center(
                              child: SpinKitCubeGrid(
                            color: Settings.COLOR_DARK_HIGHLIGHT,
                          ));
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case DataStatus.faild:
                                {
                                  widget = Center(
                                    child:
                                        Text("Error Loading upcoming Movies"),
                                  );
                                  break;
                                }
                              case DataStatus.complete:
                                {
                                  widget = snapshot.data.data.length > 0
                                      ? ListView.builder(
                                          itemExtent: screenWidth * 0.6,
                                          itemCount: 6,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              ItemVerticalView.movie(
                                                  snapshot.data.data[index]))
                                      : Center(
                                          child: Text("Empty Response"),
                                        );
                                  break;
                                }
                              default:
                            }
                          }
                          return widget;
                        })),
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
                      height: screenHeight * 0.46,
                      child: StreamBuilder<Data<List<Movie>>>(
                          stream: _moviesScreenBloc.trendingMoviesStream,
                          builder: (context, snapshot) {
                            Widget widget = Center(
                                child: SpinKitCubeGrid(
                              color: Settings.COLOR_DARK_HIGHLIGHT,
                            ));
                            if (snapshot.hasData) {
                              switch (snapshot.data.status) {
                                case DataStatus.faild:
                                  {
                                    widget = Center(
                                      child:
                                          Text("Error Loading upcoming Movies"),
                                    );
                                    break;
                                  }
                                case DataStatus.complete:
                                  {
                                    widget = snapshot.data.data.length > 0
                                        ? GridView.builder(
                                            itemCount: 6,
                                            scrollDirection: Axis.vertical,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 0.7,
                                                    crossAxisSpacing: 1,
                                                    mainAxisSpacing: 2,
                                                    crossAxisCount: 3),
                                            itemBuilder: (context, index) =>
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailsScreen.movie(
                                                                  movie: snapshot
                                                                          .data
                                                                          .data[
                                                                      index])));
                                                    },
                                                    child: Container(
                                                      width: screenWidth * 0.22,
                                                      height:
                                                          screenHeight * 0.25,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          SizedBox.expand(
                                                              child:
                                                                  CachedNetworkImage(
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    _) =>
                                                                Image.asset(
                                                                    "assets/placeholders/poster.jpg"),
                                                            imageUrl:
                                                                "${Settings.TMDB_API_IMAGE_URL}w300${snapshot.data.data[index].posterPath}",
                                                            progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                child: SizedBox(
                                                                    width:
                                                                        screenWidth *
                                                                            0.2,
                                                                    height:
                                                                        screenWidth *
                                                                            0.2,
                                                                    child: Center(
                                                                        child: CircularProgressIndicator(
                                                                            value:
                                                                                downloadProgress.progress)))),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Center(
                                                                    child: Icon(
                                                              Icons.error,
                                                              color: Settings
                                                                  .COLOR_DARK_HIGHLIGHT,
                                                            )),
                                                          )),
                                                          Positioned(
                                                              bottom:
                                                                  screenHeight *
                                                                      0.02,
                                                              child:
                                                                  MovieRatingRectangular(
                                                                text: "TMDB",
                                                                value: snapshot
                                                                    .data
                                                                    .data[index]
                                                                    .voteAverage,
                                                              ))
                                                        ],
                                                      ),
                                                    )))
                                        : Center(
                                            child: Text("Empty Response"),
                                          );
                                    break;
                                  }
                                default:
                              }
                            }
                            return widget;
                          })))
            ],
          ),
        ));
  }
}
