import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../styles.dart';

class PortfolioHeader extends StatelessWidget {

  final double total;
  final double stake;
  final TextStyle detailNumberStyle = new TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w200);
  final TextStyle detailExp = new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w900);

  PortfolioHeader({this.total, this.stake});

  @override
  Widget build(BuildContext ctx) {
    double profit = total - stake;
    NumberFormat nf = new NumberFormat("###,###,###");
    // NumberFormat nf = new NumberFormat.currency(locale: 'sv_SE', decimalDigits: 0, symbol: '', name: 'SEK');
    return new ClipPath(
      clipper: new ArcClipper(),
      child: new Container(
        width: 500.0,
        padding: const EdgeInsets.only(top: 20.0),
        decoration: new BoxDecoration(gradient: primaryGradient),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(nf.format(total), style: new TextStyle(color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.w100)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  new Text('STAKE', style: detailExp),
                  new Text(nf.format(stake), style: detailNumberStyle),
                ]),
                new Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                  new Text('PROFIT', style: detailExp),
                  new Text(nf.format(profit), style: detailNumberStyle),
                ]),
              ],
            )
          ]
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 15);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstPoint.dx, firstPoint.dy);
    var secondControlPoint =new Offset(size.width - (size.width / 4), size.height);
    var secondPoint = new Offset(size.width, size.height - 15);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondPoint.dx, secondPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}