import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:palette_generator/palette_generator.dart';

var _totalStyle = TextStyle(
    color: Colors.white,
    fontSize: 38,
    fontFamily: 'Oswald',
    fontWeight: FontWeight.w300);

class DonutChart extends StatefulWidget {
  final Map<String, double> data;
  final Map<String, double> prices;

  DonutChart({this.data, this.prices});

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  double _total = 0;
  Map<String, Color> _colors = Map();

  @override
  void initState() {
    super.initState();
    _setColors();
  }

  _setColors() async {
    widget.data.keys.forEach((symbol) async {
      var image = AssetImage('assets/images/icons/${symbol.toUpperCase()}.png');
      var palette = await PaletteGenerator.fromImageProvider(image);
      _colors[symbol] = palette.dominantColor.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    _total = 0;
    widget.data.forEach((symbol, amount) {
      double usd = 0;
      if (widget.prices.containsKey(symbol)) {
        usd = widget.prices[symbol];
      }

      _total += usd * amount;
    });

    return Center(
        child: Stack(children: [
      Container(
          width: 200,
          height: 200,
          child: Center(
              child: Text(
            '\$${_total.toStringAsFixed(2)}',
            style: _totalStyle,
          ))),
      Container(
          width: 200,
          height: 200,
          child: CustomPaint(
              painter: DonutChartPainter(
                  data: widget.data,
                  prices: widget.prices,
                  colors: _colors,
                  total: _total)))
    ]));
  }
}

class DonutChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Map<String, double> prices;
  final Map<String, Color> colors;
  final double total;

  DonutChartPainter({this.data, this.prices, this.total = 0, this.colors});

  @override
  bool shouldRepaint(DonutChartPainter old) => true;

  @override
  void paint(Canvas canvas, Size size) {
    double runningTotal = 1;

    if (data.entries.length == 0) {
      var paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeJoin = StrokeJoin.bevel;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2, paint);
      return;
    }

    data.forEach((symbol, amount) {
      var percent = prices[symbol] * amount / total;
      var paint = Paint()
        ..color = colors[symbol] ?? Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeJoin = StrokeJoin.bevel;
      canvas.drawArc(
          Rect.fromLTWH(0, 0, size.width, size.height),
          runningTotal / total * math.pi * 2 - math.pi * 2 / 4,
          percent * math.pi * 2,
          false,
          paint);
      runningTotal += prices[symbol] * amount;
    });
  }
}
