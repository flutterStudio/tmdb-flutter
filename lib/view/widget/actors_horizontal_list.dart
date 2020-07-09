import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/cast.dart';
import 'package:TMDB_Mobile/view/widget/hero_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActorsHorizontal extends StatelessWidget {
  final double size;
  final List<Cast> cast;
  ActorsHorizontal(this.size, this.cast) : assert(size != null);
  @override
  Widget build(BuildContext context) => SizedBox(
      height: size,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: cast.length >= 6 ? 6 : 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(right: size * 0.1),
                width: size,
                height: size,
                child: Container(
                  decoration: BoxDecoration(
                      color: Settings.COLOR_DARK_SECONDARY,
                      border: Border.all(
                          color: Settings.COLOR_DARK_HIGHLIGHT, width: 3),
                      borderRadius: BorderRadius.circular(size)),
                  child: HeroNetworkImage(
                    width: size,
                    height: size,
                    radius: BorderRadius.circular(size),
                    image: cast[index].profilePath == null
                        ? null
                        : "${Settings.TMDB_API_IMAGE_URL}w300${cast[index].profilePath}",
                    tag: "${Settings.HERO_IMAGE_TAG}${cast[index].id}",
                  ),
                ),
              )));
}
