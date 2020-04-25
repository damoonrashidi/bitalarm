import 'package:Bitalarm/shared/styles.dart';
import 'package:flutter/material.dart';

class ScreenHeadline extends StatelessWidget {
  final String text;
  final double opacity;

  ScreenHeadline(this.text, {this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontFamily: "Oswald",
        fontSize: 110,
        height: 1,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
        color: COLOR_HEADLINE.withOpacity(opacity));

    return Positioned(
        left: -20,
        top: -5,
        child: Text(
          text.toUpperCase(),
          overflow: TextOverflow.fade,
          style: style,
          softWrap: false,
        ));
  }
}
