import 'package:flutter/material.dart';
import '../components.dart';
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

  Color _getColor(String ticker) {
    Map<String, Color> colors = {
      'ETH' : Colors.deepOrange,
      'EOS' : Colors.black87,
      'REQ' : Colors.blue,
      'REP' : Colors.blueGrey,
      'SALT': Colors.brown,
      'OMG' : Colors.cyan,
      'VIU' : Colors.deepOrange,
      'XVG' : Colors.deepPurple,
      'RDN' : Colors.green,
      'XMR' : Colors.indigo,
      'ADA' : Colors.lightBlue,
      'BCH' : Colors.lime,
      'BTC' : Colors.orange,
      'DASH': Colors.purple,
      'LTC' : Colors.red,
    };
    if (!colors.containsKey(ticker)) {
      return Colors.white;
    } else {
      return colors[ticker];
    }
  }

  _getValues () async {
    Map<String, double> _portfolio = _wp.hardcodedList();
    List<Object> prices = await API.getPrices(currency: 'SEK');
    _total = prices.where((Object coin) => _portfolio.containsKey(coin['symbol']))
                   .map((Object coin) => double.parse(coin['price_sek']) * _portfolio[coin['symbol']])
                   .reduce((double a, double b) => a + b);
    setState(() {
      List<CircularSegmentEntry> tmp = [];
      _portfolio.forEach((String ticker, double amount) {
        tmp.add(new CircularSegmentEntry(_portfolio[ticker], _getColor(ticker), rankKey: ticker));
      });
      _data = [new CircularStackEntry(tmp, rankKey: 'Quarterly Profits',),];
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
        new ClipPath(
          clipper: new DiagonalClipper(),
          child: new Container(
            width: 800.0,
            height: 250.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [const Color(0xff2628FF), const Color(0xff1819AA)],
                stops: [0.0, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: new Border(bottom: new BorderSide(width: 0.5, color: Colors.grey),)
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  _total.toStringAsFixed(0) + " SEK", 
                  style: new TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text("Profit: " + (_total - _stake).toStringAsFixed(2)),
                    new Text("Stake: " + _stake.toStringAsFixed(2),),
                  ],
                )
              ],
            ),
          ),
        ),
        new Container(
          height: 350.0,
          padding: new EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
          child: new AnimatedCircularChart(
            key: _chartKey,
            size: const Size(300.0, 300.0),
            initialChartData: _data,
            chartType: CircularChartType.Pie,
          ),
        ),
      ],),
      bottomNavigationBar: bottomNav(ctx, 2),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 20.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}