import 'package:flutter/material.dart';

var _totalStyle = TextStyle(
    color: Colors.white,
    fontSize: 42,
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

  @override
  void initState() {
    super.initState();
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

    return Padding(
        padding: EdgeInsets.only(top: 82, bottom: 82),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                Text(
                  '\$${_total.toStringAsFixed(2)}',
                  style: _totalStyle,
                  textAlign: TextAlign.center,
                ),
                Container(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                        painter: DonutChartPainter(
                            data: widget.data, prices: widget.prices)))
              ])
            ]));
  }
}

class DonutChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Map<String, double> prices;

  DonutChartPainter({this.data, this.prices});

  @override
  bool shouldRepaint(DonutChartPainter old) => true;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.red;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width, paint);
  }
}
