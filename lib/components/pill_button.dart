import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  
  final Function onPressed;
  final Icon icon;
  final Widget child;
  final Color color;
  final double minWidth;
  PillButton({this.onPressed, this.icon, this.child, this.color, this.minWidth});
  
  @override build(BuildContext ctx) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(20.0),
      child: new MaterialButton(
        minWidth: minWidth,
        color: color,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}