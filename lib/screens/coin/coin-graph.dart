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

  double _y(double value, double height) => height - value / _max * height;
  double _x(int index, double width) => index / data.length * width;

  void _paintLabel(Canvas canvas, double value, double x, double y, Size size) {
    var paint = Paint()..color = Colors.white;
    var position = Offset(x, y);
    canvas.drawCircle(position, 3, paint);

    var textPosition = Offset(x, y);

    if (value == _max) {
      textPosition = Offset(x + 10, y - 20);
    } else if (value == _min) {
      textPosition = Offset(x + 20, y + 5);
    } else {
      textPosition = Offset(size.width - 50, y + 10);
    }

    var span = new TextSpan(
        style: new TextStyle(color: Colors.white, fontFamily: 'Oswald'),
        text: "\$${value.toStringAsFixed(2)}");
    var painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, textPosition);
  }

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
      if (value == _max || value == _min || i == data.length - 1) {
        _paintLabel(canvas, value, x, y, size);
      }
    }

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }
}
