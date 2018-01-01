import 'package:flutter/material.dart';
import '../services/api.dart';

class HistoryGraph extends StatefulWidget {

  final String ticker;
  final double height;
  HistoryGraph({this.ticker, this.height});

  @override
  createState() => new HistoryGraphState(ticker: this.ticker, height: this.height);
}

class HistoryGraphState extends State<HistoryGraph> {

  final String ticker;
  final double height;
  List<Map<String, double>> _data = [];
  double _max = 0.0;
  double _min = 0.0;

  HistoryGraphState({this.ticker, this.height});

  @override
  initState() {
    API.getHistorical(ticker).then((List<Map<String, double>> response) {
      _max = response.fold(0.0, (prev, cursor) => cursor['value'] > prev ? cursor['value'] : prev);
      _min = response.fold(_max, (prev, cursor) => cursor['value'] < prev ? cursor['value'] : prev);
      _data = new List.generate(response.length, (int i) => {
        'x': i / response.length * 900.0,
        'y': (this.height - (response[i]['value'] / _max * this.height)) * 100,
      });
      setState((){});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return new Container(
      height: this.height,
      width: 900.0,
      child: new CustomPaint(
        painter: new LineChartPainter(data: _data, max: _max, min: _min),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {

  final List<Map<String, double>> data;
  final double max;
  final double min;
  LineChartPainter({this.data, this.max, this.min});

  @override
  paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size);
    _paintChart(canvas, size);
  }

  @override
  bool shouldRepaint(LineChartPainter old) => true;

  void _paintGrid(Canvas canvas, Size size) {
    const int cols = 10;
    const int rows = 5;
    Paint paint = new Paint()
        ..strokeWidth = 0.5
        ..color       = const Color(0xee444444);
    for (int i = 0; i < cols; i++) {
      double xPos = size.width / cols * i;
      canvas.drawLine(new Offset(xPos, 0.0), new Offset(xPos, size.height), paint);
    }
    for (int i = 0; i < rows; i++) {
      double yPos = size.height / rows * i;
      canvas.drawLine(new Offset(0.0, yPos), new Offset(size.width, yPos), paint);
    }
  }

  void _paintChart(Canvas canvas, Size size) {
    double half = (this.max + this.min) / 2;
    TextPainter maxPainter = new TextPainter(
      text: new TextSpan(text: max.toString()),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    TextPainter halfPainter = new TextPainter(text: new TextSpan(text: half.toString()), textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    TextPainter minPainter = new TextPainter(text: new TextSpan(text: min.toString()), textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    maxPainter.layout();
    halfPainter.layout();
    minPainter.layout();
    maxPainter.paint(canvas, new Offset(5.0, 5.0));
    halfPainter.paint(canvas, new Offset(5.0, size.height / 2));
    minPainter.paint(canvas, new Offset(5.0, size.height - 5.0));
    for (int i = 1; i < this.data.length; i++) {
      Paint paint = new Paint()
        ..strokeWidth = 3.0
        ..color       = this.data[i]['y'] > this.data[i-1]['y'] ? Colors.red : Colors.blue;
      double toX = this.data[i]['x'];
      double toY = this.data[i]['y'];
      double fromX = this.data[i-1]['x'];
      double fromY = this.data[i-1]['y'];
      canvas.drawLine(new Offset(fromX, fromY), new Offset(toX, toY), paint);
      // canvas.drawRect(new Rect.fromLTWH(x, size.height - y, 1.5, y), paint);
    }
  }
}
