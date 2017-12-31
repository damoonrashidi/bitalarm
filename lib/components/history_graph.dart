import 'package:flutter/material.dart';
import '../services/api.dart';

class HistoryGraph extends StatefulWidget {

  final String ticker;
  HistoryGraph({this.ticker});

  @override
  createState() => new HistoryGraphState(ticker: this.ticker);
}

class HistoryGraphState extends State<HistoryGraph> {

  final String ticker;
  List<Map<String, double>> data = [];

  HistoryGraphState({this.ticker});

  @override
  initState() {
    API.getHistorical(ticker).then((response) {
      this.data = response;
      debugPrint(response.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return new Center(child: 
      new Text('This is the history graph')
    );
  }
}