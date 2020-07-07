import 'dart:ui';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/model/tvshow_model.dart';
import 'package:TMDB_Mobile/view/screen/details_screen.dart';
import 'package:TMDB_Mobile/view/widget/hero_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemStackedView extends StatelessWidget {
  final double _width;
  final double _height;
  final Movie _movie;
  final Color _highlight;
  final bool _offline;
  final String _image;
  final TvShow _tvShow;
  final String _heroTag;

  ItemStackedView.movie({
    double width,
    double height,
    Movie movie,
    String heroTag,
    Color highlight = Settings.COLOR_DARK_HIGHLIGHT,
    bool offline = true,
  })  : _movie = movie,
        _height = height,
        _width = width,
        _offline = offline,
        _heroTag = heroTag,
        _image = movie.posterPath,
        _tvShow = null,
        _highlight = highlight,
        assert(movie != null),
        assert(height != null),
        assert(width != null);

  ItemStackedView.tv({
    double width,
    double height,
    String heroTag,
    TvShow tvShow,
    Color highlight = Settings.COLOR_DARK_HIGHLIGHT,
    bool offline = true,
  })  : _movie = null,
        _height = height,
        _width = width,
        _image = tvShow.posterPath,
        _heroTag = heroTag,
        _tvShow = tvShow,
        _offline = offline,
        _highlight = highlight,
        assert(tvShow != null),
        assert(height != null),
        assert(width != null);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Settings.COLOR_DARK_SECONDARY,
            borderRadius:
                BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS)),
      ),
      _offline || _image == null
          ? Center(
              child: Icon(
              Icons.error,
              color: _highlight,
            ))
          : HeroNetworkImage(
              tag: _heroTag,
              width: _width,
              height: _height,
              destination: _movie != null
                  ? DetailsScreen.movie(
                      heroTag: _heroTag,
                      movie: _movie,
                    )
                  : DetailsScreen.tvShow(
                      heroTag: _heroTag,
                      tvShow: _tvShow,
                    ),
              image:
                  "${Settings.TMDB_API_IMAGE_URL}w300${_movie != null ? _movie.posterPath : _tvShow.posterPath}",
            ),
      // SizedBox(
      //     width: _width,
      //     height: _height,
      //     child: Hero(
      //         tag: _heroTag,
      //         createRectTween: (begin, end) =>
      //             MaterialRectCenterArcTween(begin: begin, end: end),
      //         transitionOnUserGestures: true,
      //         child: Material(
      //             color: Colors.transparent,
      //             child: InkWell(
      //                 onTap: () {
      //                   if (_movie != null || _tvShow != null) {
      //                     Navigator.of(context).push(MaterialPageRoute(
      //                         builder: (context) => _movie != null
      //                             ? DetailsScreen.movie(movie: _movie)
      //                             : DetailsScreen.tvShow(tvShow: _tvShow)));
      //                   }
      //                 },
      //                 child: CachedNetworkImage(
      //                   fit: BoxFit.fill,
      //                   placeholder: (context, _) =>
      //                       Image.asset("assets/placeholders/poster.jpg"),
      //                   imageUrl:
      //                       "${Settings.TMDB_API_IMAGE_URL}w300${_movie != null ? _movie.posterPath : _tvShow.posterPath}",
      //                   progressIndicatorBuilder:
      //                       (context, url, downloadProgress) => Center(
      //                           child: SizedBox(
      //                               width: _width * 0.2,
      //                               height: _width * 0.2,
      //                               child: Center(
      //                                   child: CircularProgressIndicator(
      //                                       value: downloadProgress
      //                                           .progress)))),
      //                   errorWidget: (context, url, error) => Center(
      //                       child: Icon(
      //                     Icons.error,
      //                     color: Settings.COLOR_DARK_HIGHLIGHT,
      //                   )),
      //                 ))))),
      Positioned(
          left: _width * 0.02,
          bottom: _height * 0.02,
          child: Container(
            color: Settings.COLOR_DARK_HIGHLIGHT,
            padding: EdgeInsets.all(2),
            child: Text(_movie != null ? "movie" : "Tv"),
          ))
    ]);
  }
}
