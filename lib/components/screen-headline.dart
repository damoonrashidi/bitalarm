import 'package:Bitalarm/shared/styles.dart';
import 'package:flutter/material.dart';

class ScreenHeadline extends StatelessWidget {
  final String text;

  ScreenHeadline(this.text);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(-30, -30),
        child: Text(text, overflow: TextOverflow.clip, style: HeadlineStyle));
  }
}
