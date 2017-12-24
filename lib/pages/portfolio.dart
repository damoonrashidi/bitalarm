import 'package:flutter/material.dart';
import '../components.dart';
import '../styles.dart';
import '../helpers/services.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PortfolioPageState createState() => new _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  List<Row> _list = [];
  double _total = 0.0;
  double _stake = 21000.0;
  WalletProvider _wp = new WalletProvider();
  List<CircularStackEntry> _data = [];
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  _getValues () async {
    Map<String, double> _portfolio = _wp.hardcodedList();
    List<Object> prices = await API.getPrices(currency: 'SEK');
    _list = [];
    setState(() {
      _total = prices.where((Object coin) => _portfolio.containsKey(coin['symbol']))
                    .map((Object coin) => double.parse(coin['price_sek']) * _portfolio[coin['symbol']])
                    .reduce((double a, double b) => a + b);
      List<CircularSegmentEntry> tmp = [];
      _portfolio.forEach((String ticker, double amount) {
        tmp.add(new CircularSegmentEntry(_portfolio[ticker], getTickerColor(ticker), rankKey: ticker));
        _list.add(new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(ticker),
            new Text(_portfolio[ticker].toStringAsFixed(1))
          ],
        ));
      });
      _data = [new CircularStackEntry(tmp, rankKey: 'Data Bois',),];
      _chartKey.currentState.updateData(_data);
    });
  }

  _PortfolioPageState () {
    _getValues();
  }

  @override
  Widget build (BuildContext ctx) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        headerArc(_total, _stake),
        new Container(
          height: 280.0,
          padding: new EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
          child: new AnimatedCircularChart(
            duration: const Duration(milliseconds: 500),
            key: _chartKey,
            size: const Size(280.0, 280.0),
            initialChartData: _data,
            chartType: CircularChartType.Radial,
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          width: 900.0,
          height: 150.0,
          child: new ListView(
            children: _list,
          ),
        )
      ],),
      bottomNavigationBar: bottomNav(ctx, 2),
    );
  }
}
