import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/model/tvshow_model.dart';
import 'package:TMDB_Mobile/view/screen/details_screen.dart';
import 'package:TMDB_Mobile/view/widget/movie_rating_rectangular.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemVerticalView extends StatelessWidget {
  final Movie _movie;
  final TvShow _tvShow;
  ItemVerticalView.movie(Movie movie)
      : _movie = movie,
        _tvShow = null,
        assert(movie != null);
  ItemVerticalView.tvShow(TvShow tvShow)
      : _movie = null,
        _tvShow = tvShow,
        assert(tvShow != null);
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    if (_movie != null || _tvShow != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => _movie != null
                              ? DetailsScreen.movie(movie: _movie)
                              : DetailsScreen.tvShow(tvShow: _tvShow)));
                    }
                  },
                  child: SizedBox(
                      height: screenHeight * 0.35,
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        placeholder: (context, _) =>
                            Image.asset("assets/placeholders/poster.jpg"),
                        imageUrl:
                            "${Settings.TMDB_API_IMAGE_URL}w300${_movie != null ? _movie.posterPath : _tvShow.posterPath}",
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
                      ))),
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
                value:
                    _movie != null ? _movie.voteAverage : _tvShow.voteAverage,
              )
            ]));
  }
}
