import 'dart:async';
import 'package:flutter/material.dart';
import '../components/orderbook.dart';
import '../components/history_graph.dart';

class DetailsPage extends StatefulWidget {
  final String ticker;
  DetailsPage({Key key, this.ticker}) : super(key: key);
  DetailsState createState() => new DetailsState(ticker: this.ticker);
}

class DetailsState extends State<DetailsPage> {
  final String ticker;
  List<double> yValues = [];
  List<String> xNames = [];
  double maxY = 0.0;

  DetailsState({this.ticker});

  Future<dynamic> getData() async {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    this.getData();
  }

  @override
  build(BuildContext ctx) {
    Orderbook orderbook = new Orderbook(ticker: ticker);
    HistoryGraph graph = new HistoryGraph(ticker: ticker, height: 200.0);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: const Color(0xff222222),
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(ctx)),
        title: new Text(ticker),
      ),
      backgroundColor: const Color(0xff222222),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Container(
            decoration: new BoxDecoration(
              border: new Border(
                bottom: const BorderSide(color: const Color(0xff444444))),
            ),
            child: graph,
          ),
          new Expanded(child: orderbook),
        ]
      )
    );
  }
}
