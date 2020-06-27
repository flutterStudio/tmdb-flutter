import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularRating extends StatelessWidget {
  final double size;
  final double value;
  final Color color;
  final AnimationController controller;
  final Animation<double> valueAnimation;
  CircularRating(this.value, this.size, this.controller,
      {this.color = Settings.COLOR_DARK_SECONDARY})
      : valueAnimation = Tween<double>(
          begin: 0.0,
          end: value,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0, 0.2, curve: Curves.ease),
          ),
        ),
        assert(size != null && value != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, staticWidget) => Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                value: valueAnimation.value,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Settings.COLOR_DARK_HIGHLIGHT),
              ),
              Text(
                "${valueAnimation.value.toStringAsFixed(1)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Settings.COLOR_DARK_TEXT,
                    fontWeight: FontWeight.w400,
                    fontSize: size * 0.3),
              )
            ],
          ),
        ));
  }
}
