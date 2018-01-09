import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import '../../styles.dart';

class PortfolioChart extends StatelessWidget {

  final List<Object> data;
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  PortfolioChart({this.data});

  @override
  Widget build(BuildContext ctx) {
    List<CircularSegmentEntry> stacks = new List.generate(this.data.length, (int i) {
      return new CircularSegmentEntry(this.data[i]['value'], getSymbolColor(this.data[i]['symbol'].toString().toUpperCase()));
    });
    return new AnimatedCircularChart(
      duration: const Duration(milliseconds: 500),
      key: _chartKey,
      size: const Size(280.0, 280.0),
      initialChartData: [new CircularStackEntry(stacks)],
      chartType: CircularChartType.Radial,
    );
  }

}