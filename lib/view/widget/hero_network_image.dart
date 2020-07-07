import 'package:TMDB_Mobile/common/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnHeroTap = void Function();

class HeroNetworkImage extends StatelessWidget {
  final double _width;
  final double _height;
  final double _radius;
  final String _tag;
  final String _image;
  final Widget _placeholder;
  final Widget _errorWidget;
  final Widget _destination;

  HeroNetworkImage(
      {@required String image,
      double width = double.infinity,
      double height = double.infinity,
      @required String tag,
      double radius = 0.0,
      Widget destination,
      Widget placeholder,
      Widget errorWidget})
      : _width = width,
        _height = height,
        _radius = radius,
        _tag = tag,
        _destination = destination,
        _image = image,
        _placeholder = placeholder,
        _errorWidget = errorWidget;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        height: _height,
        child: Hero(
            tag: _tag,
            createRectTween: (begin, end) =>
                MaterialRectCenterArcTween(begin: begin, end: end),
            transitionOnUserGestures: true,
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () => _destination != null
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _destination))
                        : null,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(_radius),
                        child: _image != null
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, _) =>
                                    _placeholder != null
                                        ? _placeholder
                                        : Image.asset(
                                            "assets/placeholders/poster.jpg"),
                                imageUrl: _image,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                        child: SizedBox(
                                            width: _width * 0.2,
                                            height: _height * 0.2,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress)))),
                                errorWidget: (context, url, error) =>
                                    _errorWidget != null
                                        ? _errorWidget
                                        : Center(
                                            child: Icon(
                                            Icons.error,
                                            color:
                                                Settings.COLOR_DARK_HIGHLIGHT,
                                          )),
                              )
                            : Center(
                                child: Icon(
                                Icons.error,
                                color: Settings.COLOR_DARK_HIGHLIGHT,
                              )))))));
  }
}
