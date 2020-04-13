import 'dart:math';

import 'package:flutter/material.dart';

class CoinGraph extends StatelessWidget {
  final List<double> data;

  CoinGraph({this.data});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(86, 116, 228, 1),
              Color.fromRGBO(255, 104, 104, 1),
            ]).createShader(bounds);
      },
      child: CustomPaint(painter: CoinChartPainter(data: data)),
    );
  }
}

class CoinChartPainter extends CustomPainter {
  final List<double> data;
  double _max;
  double _min;

  CoinChartPainter({this.data}) {
    if (data.length == 0) {
      _min = 0;
      _max = 0;
    } else {
      _max = data.reduce((peak, current) => max(peak, current));
      _min = data.reduce((low, current) => min(low, current));
    }
  }

  @override
  bool shouldRepaint(CoinChartPainter old) => true;

  double getYPosition(double value, double max, double height) {
    return height - value / max * height;
  }

  void _paintLabel(Canvas canvas, double value, double x, double y) {
    var paint = Paint()..color = Colors.white;
    var position = Offset(x, y);
    canvas.drawCircle(position, 4, paint);
    var span = new TextSpan(
        style: new TextStyle(color: Colors.white, fontFamily: 'Oswald'),
        text: "\$${value.toStringAsFixed(2)}");
    var painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, position);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;

    Path path = Path();

    path.moveTo(0, getYPosition(data[0], _max, height));
    for (var i = 0; i < data.length; i++) {
      double x = i / (data.length - 1) * width;
      double y = getYPosition(data[i], _max, height);
      path.lineTo(x, y);
      if (data[i] == _max || data[i] == _min || i == data.length - 1) {
        _paintLabel(canvas, data[i], x, y);
      }
    }

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }
}
