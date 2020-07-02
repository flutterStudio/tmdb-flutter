import 'dart:ui';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/widgets.dart';

class MovieStackedView extends StatelessWidget {
  final double _width;
  final double _height;
  final String _image;
  final String _name;
  final Color _highlight;

  MovieStackedView(
      {double width, double height, String name, String image, Color highlight})
      : _image = image,
        _height = height,
        _width = width,
        _name = name,
        _highlight = highlight,
        assert(image != null),
        assert(height != null),
        assert(width != null),
        assert(name != null);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
            color: Settings.COLOR_DARK_SECONDARY,
            image:
                DecorationImage(fit: BoxFit.cover, image: AssetImage(_image)),
            borderRadius:
                BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS)),
      ),
      Positioned(
        bottom: 0,
        width: _width,
        height: _height * 0.25,
        child: BackdropFilter(
          filter: ImageFilter.blur(),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _height * 0.02, horizontal: _width * 0.05),
            width: _width,
            height: _height * 0.25,
            color: _highlight.withOpacity(0.7),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(_name,
                    maxLines: 1,
                    style: TextStyle(
                        color: Settings.COLOR_DARK_TEXT,
                        fontWeight: FontWeight.w300,
                        fontSize:
                            _width * Settings.FONT_SIZE_EXTRA_LARGE_FACTOR)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Oct 10, 2012",
                        style: TextStyle(
                            color: Settings.COLOR_DARK_TEXT,
                            fontWeight: FontWeight.w300,
                            fontSize: _width * Settings.FONT_SIZE_MEDIUM)),
                    Text("Rating",
                        style: TextStyle(
                            color: Settings.COLOR_DARK_TEXT,
                            fontWeight: FontWeight.w300,
                            fontSize: _width * Settings.FONT_SIZE_MEDIUM))
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
