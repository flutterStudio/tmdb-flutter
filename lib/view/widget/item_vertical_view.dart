import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/model/tvshow_model.dart';
import 'package:TMDB_Mobile/view/screen/details_screen.dart';
import 'package:TMDB_Mobile/view/widget/hero_network_image.dart';
import 'package:TMDB_Mobile/view/widget/movie_rating_rectangular.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemVerticalView extends StatelessWidget {
  final Movie _movie;
  final String _heroTag;
  final TvShow _tvShow;
  ItemVerticalView.movie(Movie movie, {String heroTag})
      : _movie = movie,
        _tvShow = null,
        _heroTag = heroTag,
        assert(
          movie != null,
        );
  ItemVerticalView.tvShow(TvShow tvShow, {String heroTag})
      : _movie = null,
        _tvShow = tvShow,
        _heroTag = heroTag,
        assert(tvShow != null);
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
              child: HeroNetworkImage(
            width: screenWidth * 0.5,
            height: screenHeight * 0.35,
            tag: _heroTag,
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
          )),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Text(
            "${_movie != null ? _movie.title : _tvShow.name}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: screenWidth * Settings.FONT_SIZE_MEDIUM,
                fontWeight: FontWeight.w300,
                color: Settings.COLOR_DARK_TEXT),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          MovieRatingRectangular(
            text: "TMDB",
            value: _movie != null ? _movie.voteAverage : _tvShow.voteAverage,
          )
        ]));
  }
}
