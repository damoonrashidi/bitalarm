import 'package:flutter/material.dart';
import './styles.dart';

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 15);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height);
    var secondPoint = new Offset(size.width, size.height - 15);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

ClipPath headerArc (double total, double stake) {
  String profitAsPercent = (total / stake * 100).toStringAsFixed(2);
  return new ClipPath(
    clipper: new ArcClipper(),
    child: new Container(
      padding: const EdgeInsets.only(top: 40.0, bottom: 32.0),
      width: 900.0,
      height: 220.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [const Color(0xff2628FF), const Color(0xff1819AA)],
          stops: [0.0, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: new Border(bottom: new BorderSide(width: 0.5, color: Colors.grey),)
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              new Text(total.toStringAsFixed(0), style: const TextStyle(fontSize: 45.0, fontWeight: FontWeight.w300, color: Colors.white,),),
              new Text('SEK', style: const TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w100),)
            ]
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('Stake', style: headerColumnLabel),
                  new Text(stake.toStringAsFixed(0) + " SEK", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.0)),
                ],
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text('Profit $profitAsPercent%', style: headerColumnLabel),
                  new Text((total - stake).toStringAsFixed(0) + " SEK", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.0)),
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}