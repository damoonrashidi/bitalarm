import 'dart:math';

import 'package:flutter/material.dart';

class CoinGraphLabels extends StatelessWidget {
  final List<double> data;

  CoinGraphLabels({this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CoinChartLabelPainter(data: data));
  }
}

class CoinChartLabelPainter extends CustomPainter {
  final List<double> data;
  double _max;
  double _min;

  CoinChartLabelPainter({this.data}) {
    if (data.length == 0) {
      _min = 0;
      _max = 0;
    } else {
      _max = data.reduce((peak, current) => max(peak, current));
      _min = data.reduce((low, current) => min(low, current));
    }
  }

  @override
  bool shouldRepaint(CoinChartLabelPainter old) => true;

  double _y(double value, double height) {
    var weight = height / (_max - _min);
    return height - (value - _min) * weight;
  }

  double _x(int index, double width) => index / data.length * width;

  void _paintLabel(Canvas canvas, double value, double x, double y, Size size) {
    var paint = Paint()..color = Colors.white;
    var position = Offset(x, y);
    canvas.drawCircle(position, 3, paint);

    var textPosition = Offset(x, y);

    if (value == _max) {
      textPosition = Offset(x + 10, y - 20);
    } else if (value == _min) {
      textPosition = Offset(x + 20, y - 10);
    } else {
      textPosition = Offset(size.width - 50, y - 10);
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
    for (var i = 0; i < data.length; i++) {
      var value = data[i];
      double x = _x(i, width);
      double y = _y(value, height);

      if (value == _max || value == _min || i == data.length - 1) {
        _paintLabel(canvas, value, x, y, size);
      }
    }
  }
}
