import 'package:flutter/material.dart';

class ScreenHeadline extends StatelessWidget {
  final String text;
  final double opacity;

  ScreenHeadline(this.text, {this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontFamily: "Oswald",
        fontSize: 80,
        height: 1,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(opacity));

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
