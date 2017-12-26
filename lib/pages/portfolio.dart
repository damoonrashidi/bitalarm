import 'package:flutter/material.dart';
import '../components.dart';
import '../styles.dart';
import '../helpers/services.dart';
import '../helpers/portfolio.helper.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PortfolioPageState createState() => new _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  List<TableRow> _list = [];
  double _total = 0.0;
  double _stake = 21000.0;
  Map<String, double> _pricesInSEK;
  WalletProvider _wp = new WalletProvider();
  List<CircularStackEntry> _data = [];
  AnimatedCircularChart _radialChart;
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  _getValues () async {
    Map<String, double> _portfolio = _wp.hardcodedList();
    List<Object> prices = await API.getPrices(currency: 'SEK');
    _list = [];
    setState(() {
      _pricesInSEK = convertPortfolioToSEK(_portfolio, prices);
      _total = prices.where((Object coin) => _portfolio.containsKey(coin['symbol']))
                    .map((Object coin) => double.parse(coin['price_sek']) * _portfolio[coin['symbol']])
                    .reduce((double a, double b) => a + b);
      List<CircularSegmentEntry> tmp = [];
      _portfolio.forEach((String ticker, double amount) {
        tmp.add(new CircularSegmentEntry(_pricesInSEK[ticker], getTickerColor(ticker), rankKey: ticker));
        _list.add(new TableRow(
          children: <Widget>[
            new Text(ticker),
            new Text(_pricesInSEK[ticker].toStringAsFixed(0) + " SEK", textAlign: TextAlign.right,),
          ],
        ));
      });
      _data = [new CircularStackEntry(tmp, rankKey: 'Data Bois',),];
      _chartKey.currentState.updateData(_data);
    });
  }

  @override
  void initState() {
    super.initState();
    _radialChart = new AnimatedCircularChart(
      duration: const Duration(milliseconds: 500),
      key: _chartKey,
      size: const Size(280.0, 280.0),
      initialChartData: _data,
      chartType: CircularChartType.Radial,
    );
    _getValues();
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          headerArc(_total, _stake),
          new Container(
            height: 505.0,
            width: 900.0,
            margin: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: new PageView(
              controller: new PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0),
              scrollDirection: Axis.vertical,
              pageSnapping: true,
              children: <Widget>[
                _radialChart,
                new Center(child: new Table(children: _list,)),
              ],
            )
          ),
        ],
      ),
      bottomNavigationBar: bottomNav(ctx, 2),
    );
  }
}
