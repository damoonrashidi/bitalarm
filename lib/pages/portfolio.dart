import 'package:flutter/material.dart';
import '../components.dart';
import '../helpers/services.dart';
import '../styles.dart';
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
      'ETH' : Colors.orangeAccent[500],
      'EOS' : Colors.grey[200],
      'REQ' : Colors.blue[200],
      'REP' : Colors.blueGrey[200],
      'SALT': Colors.brown[200],
      'OMG' : Colors.cyan[200],
      'VIU' : Colors.deepOrange[200],
      'XVG' : Colors.deepPurple[200],
      'RDN' : Colors.green[200],
      'XMR' : Colors.indigo[200],
      'ADA' : Colors.lightBlue[200],
      'BCH' : Colors.lime[200],
      'BTC' : Colors.orange[200],
      'DASH': Colors.purple[200],
      'LTC' : Colors.red[200],
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
          clipper: new ArcClipper(),
          child: new Container(
            padding: const EdgeInsets.only(top: 8.0),
            width: 800.0,
            height: 200.0,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new Text(_total.toStringAsFixed(0), style: const TextStyle(fontSize: 45.0, fontWeight: FontWeight.w300, color: Colors.white,),),
                    new Text('SEK', style: const TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w100),)
                  ]
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('STAKE', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w100, fontSize: 10.0),),
                        new Text(_stake.toStringAsFixed(2) + " SEK", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.0)),
                      ],
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text('Profit', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w100, fontSize: 10.0),),
                        new Text((_total - _stake).toStringAsFixed(2) + " SEK", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.0)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        new Container(
          height: 350.0,
          padding: new EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
          // child: new AnimatedCircularChart(
          //   key: _chartKey,
          //   size: const Size(300.0, 300.0),
          //   initialChartData: _data,
          //   chartType: CircularChartType.Pie,
          // ),
        ),
      ],),
      bottomNavigationBar: bottomNav(ctx, 2),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 15);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height);
    var secondPoint = new Offset(size.width, size.height - 15);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}