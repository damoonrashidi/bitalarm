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

  CoinChartPainter({this.data}) {
    if (data.length > 0) {
      _max = data.reduce((peak, current) => max(peak, current));
    }
  }

  @override
  bool shouldRepaint(CoinChartPainter old) => true;

  double _y(double value, double height) => height - value / _max * height;
  double _x(int index, double width) => index / data.length * width;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length == 0) {
      return;
    }
    var width = size.width;
    var height = size.height;

    Path path = Path();

    path.moveTo(0, _y(data[0], height));
    for (var i = 1; i < data.length; i++) {
      var value = data[i];
      double x = _x(i, width);
      double y = _y(value, height);

      path.lineTo(x, y);
    }

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }
}
