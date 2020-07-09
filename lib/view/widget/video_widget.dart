import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/video.dart';
import 'package:TMDB_Mobile/utils/utils.dart';
import 'package:TMDB_Mobile/view/widget/hero_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ONCLICK = void Function();

class VideoItemView extends StatelessWidget {
  final double _radius;
  final Color _background;
  final Video _video;
  final double _width;
  final double _height;

  VideoItemView(
      {@required double radius,
      @required double width,
      @required double height,
      Color background = Settings.COLOR_DARK_PRIMARY,
      @required Video video})
      : _radius = radius,
        _height = height,
        _width = width,
        _background = background,
        _video = video;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Stack(children: <Widget>[
          Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
                color: _background,
                borderRadius: BorderRadius.circular(_radius),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset(10, 10),
                      color: Colors.black.withOpacity(0.25))
                ]),
          ),
          SizedBox(
              height: _height,
              width: _width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  HeroNetworkImage(
                      width: _width,
                      height: _height * 0.7,
                      radius: BorderRadius.only(
                          topLeft: Radius.circular(_radius),
                          topRight: Radius.circular(_radius)),
                      image: Utils.youtubeThumnail(_video.key),
                      tag: "${Settings.HERO_IMAGE_TAG}_VIDEO_${_video.id}"),
                  Container(
                      width: _width,
                      padding: EdgeInsets.symmetric(
                          vertical: _height * 0.05, horizontal: _width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              width: _height * 0.2,
                              height: _height * 0.2,
                              decoration: BoxDecoration(
                                  color: Settings.COLOR_DARK_SECONDARY,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  size: _height * 0.1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: _width * 0.1,
                          ),
                          Expanded(
                              child: Text(
                            _video.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Settings.COLOR_DARK_TEXT,
                                fontSize: _width * Settings.FONT_SIZE_MEDIUM),
                          ))
                        ],
                      ))
                ],
              ))
        ]));
  }
}
