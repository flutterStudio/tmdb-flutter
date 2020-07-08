import 'dart:ui';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/cast.dart';
import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/model/tvshow_model.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/details_screen_bloc.dart';
import 'package:TMDB_Mobile/view/widget/actors_horizontal_list.dart';
import 'package:TMDB_Mobile/view/widget/genre_widget.dart';
import 'package:TMDB_Mobile/view/widget/hero_network_image.dart';
import 'package:TMDB_Mobile/view/widget/horizontal_movie_options.dart';
import 'package:TMDB_Mobile/view/widget/item_vertical_view.dart';
import 'package:TMDB_Mobile/view/widget/parental_guide_.dart';
import 'package:TMDB_Mobile/view/widget/screen_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailsScreen extends StatefulWidget {
  final Movie _movie;
  final TvShow _tvShow;
  final String _heroTag;
  final bool _isMovie;
  DetailsScreen.movie({@required Movie movie, String heroTag})
      : _movie = movie,
        _tvShow = null,
        _isMovie = true,
        _heroTag = heroTag,
        assert(movie != null);

  DetailsScreen.tvShow({@required TvShow tvShow, String heroTag})
      : _movie = null,
        _isMovie = false,
        _tvShow = tvShow,
        _heroTag = heroTag,
        assert(tvShow != null);
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  DetailsScreenBloc _detailScreenBloc;
  @override
  void initState() {
    _detailScreenBloc = DetailsScreenBloc();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
      upperBound: 1,
      lowerBound: 0,
    );
    _animationController.animateTo(0.2);

    _detailScreenBloc.getData(
        widget._isMovie ? widget._movie.id : widget._tvShow.id,
        widget._isMovie);
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
                    // Background Image
                    Container(
                      height: screenHeight * 1.4,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, _) =>
                            Image.asset("assets/placeholders/poster.jpg"),
                        imageUrl:
                            "${Settings.TMDB_API_IMAGE_URL}w300${widget._isMovie ? widget._movie.posterPath : widget._tvShow.posterPath}",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: SizedBox(
                                    width: screenWidth * 0.2,
                                    height: screenWidth * 0.2,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            value:
                                                downloadProgress.progress)))),
                        errorWidget: (context, url, error) => Center(
                            child: Icon(
                          Icons.error,
                          color: Settings.COLOR_DARK_HIGHLIGHT,
                        )),
                      ),
                    ),
                    // ),
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
                            widget._isMovie
                                ? widget._movie.title
                                : widget._tvShow.name,
                            textAlign: TextAlign.center,
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
                              // Poster
                              SizedBox(
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.35,
                                child: HeroNetworkImage(
                                  tag: widget._heroTag,
                                  width: screenWidth * 0.45,
                                  height: screenHeight * 0.4,
                                  destination: widget._movie != null
                                      ? DetailsScreen.movie(
                                          movie: widget._movie,
                                        )
                                      : DetailsScreen.tvShow(
                                          tvShow: widget._tvShow,
                                        ),
                                  image:
                                      "${Settings.TMDB_API_IMAGE_URL}w300${widget._movie != null ? widget._movie.posterPath : widget._tvShow.posterPath}",
                                ),
                              ),
                              // info Section
                              StreamBuilder<dynamic>(
                                  stream: _detailScreenBloc.detailsStream,
                                  builder: (context, snapShot) {
                                    Widget cusomWidget = Container(
                                        width: screenWidth * 0.5,
                                        height: screenHeight * 0.3,
                                        child: Center(
                                            child: SpinKitCubeGrid(
                                          color: Settings.COLOR_DARK_HIGHLIGHT,
                                        )));
                                    if (snapShot.hasData) {
                                      switch (snapShot.data.status) {
                                        case DataStatus.faild:
                                          {
                                            cusomWidget = Center(
                                              child: Text(
                                                  "Error Loading upcoming Movies"),
                                            );
                                            break;
                                          }
                                        case DataStatus.complete:
                                          {
                                            cusomWidget = Container(
                                                width: screenWidth * 0.5,
                                                height: screenHeight * 0.3,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      widget._isMovie
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                    flex: 1,
                                                                    child: Icon(
                                                                      Icons
                                                                          .access_time,
                                                                      size: screenWidth *
                                                                          Settings
                                                                              .FONT_SIZE_MEDIUM,
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                Expanded(
                                                                    flex: 4,
                                                                    child: Text(
                                                                      "${snapShot.data.data.runtime.toString()} minutes",
                                                                      style: TextStyle(
                                                                          color: Settings
                                                                              .COLOR_DARK_TEXT,
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          fontSize:
                                                                              screenWidth * Settings.FONT_SIZE_SMALL),
                                                                    ))
                                                              ],
                                                            )
                                                          : Container(),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      ParentalGuide(age: 17),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Expanded(
                                                              flex: 1,
                                                              child: Icon(
                                                                Icons
                                                                    .new_releases,
                                                                size: screenWidth *
                                                                    Settings
                                                                        .FONT_SIZE_MEDIUM,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          Expanded(
                                                              flex: 4,
                                                              child: Text(
                                                                "09/20/2019 (US)",
                                                                style: TextStyle(
                                                                    color: Settings
                                                                        .COLOR_DARK_TEXT,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
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
                                                        direction:
                                                            Axis.horizontal,
                                                        alignment:
                                                            WrapAlignment.start,
                                                        spacing: 2,
                                                        runAlignment:
                                                            WrapAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          GenreWidget(Genre(1,
                                                              "Science Ficition")),
                                                        ],
                                                      ),
                                                      Expanded(
                                                          child: Container())
                                                    ]));
                                            break;
                                          }
                                        default:
                                      }
                                    }
                                    return cusomWidget;
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight *
                                Settings.VERTICAL_SCREEN_SECTIONS_PADDING,
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenHeight * 0.01),
                            child: HorizontalMovieOptionsPanel(
                              _animationController,
                              value: widget._isMovie
                                  ? widget._movie.voteAverage
                                  : widget._tvShow.voteAverage,
                            ),
                          ),
                          ScreenSection(
                            background: Colors.transparent,
                            title: "Overview",
                            body: Text(
                              widget._isMovie
                                  ? widget._movie.overview
                                  : widget._tvShow.overview,
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
                              body: StreamBuilder<Data<List<Cast>>>(
                                  stream: _detailScreenBloc.castStream,
                                  builder: (context, snapShot) {
                                    Widget widget = Center(
                                        child: SpinKitCubeGrid(
                                      color: Settings.COLOR_DARK_HIGHLIGHT,
                                    ));
                                    if (snapShot.hasData) {
                                      switch (snapShot.data.status) {
                                        case DataStatus.faild:
                                          {
                                            widget = Center(
                                              child: Text(
                                                  "Error Loading upcoming Movies"),
                                            );
                                            break;
                                          }
                                        case DataStatus.complete:
                                          {
                                            widget = snapShot.data.data.length >
                                                    0
                                                ? ActorsHorizontal(
                                                    screenWidth * 0.25,
                                                    snapShot.data.data,
                                                  )
                                                : Center(
                                                    child:
                                                        Text("Empty Response"),
                                                  );
                                            break;
                                          }
                                        default:
                                      }
                                    }
                                    return widget;
                                  })),
                          ScreenSection(
                            horizontalPadding:
                                screenWidth * Settings.VERTICAL_SCREEN_PADDING,
                            body: Container(
                                height: screenHeight * 0.5,
                                child: StreamBuilder<dynamic>(
                                    stream: _detailScreenBloc.similarDataStream,
                                    builder: (context, snapshot) {
                                      Widget customWidget = Center(
                                          child: SpinKitCubeGrid(
                                        color: Settings.COLOR_DARK_HIGHLIGHT,
                                      ));
                                      if (snapshot.hasData) {
                                        switch (snapshot.data.status) {
                                          case DataStatus.faild:
                                            {
                                              customWidget = Center(
                                                child: Text(
                                                    "Error Loading upcoming Movies"),
                                              );
                                              break;
                                            }
                                          case DataStatus.complete:
                                            {
                                              customWidget = snapshot
                                                          .data.data.length >
                                                      0
                                                  ? ListView.builder(
                                                      itemExtent:
                                                          screenWidth * 0.6,
                                                      itemCount: 6,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder: (context,
                                                              index) =>
                                                          widget._isMovie
                                                              ? ItemVerticalView
                                                                  .movie(
                                                                  snapshot.data
                                                                          .data[
                                                                      index],
                                                                  heroTag:
                                                                      "${Settings.HERO_IMAGE_TAG}_VIDEO_UPCOMING_${snapshot.data.data[index].id}",
                                                                )
                                                              : ItemVerticalView
                                                                  .tvShow(
                                                                  snapshot.data
                                                                          .data[
                                                                      index],
                                                                  heroTag:
                                                                      "${Settings.HERO_IMAGE_TAG}_VIDEO_UPCOMING_${snapshot.data.data[index].id}",
                                                                ))
                                                  : Center(
                                                      child: Text(
                                                          "Empty Response"),
                                                    );
                                              break;
                                            }
                                          default:
                                        }
                                      }
                                      return customWidget;
                                    })),
                            onViewMore: null,
                            title: "Popular",
                          ),
                        ]),
                  ],
                ))));
  }
}
