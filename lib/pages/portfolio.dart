import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:barcode_scan/barcode_scan.dart';

import '../services/api.dart';
import '../services/portfolio.service.dart';
import '../services/wallet.service.dart';

import '../components/bottom_nav.dart';
import '../components/portfolio/wallet_list.dart';
import '../components.dart';
import '../styles.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PortfolioPageState createState() => new _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  List<DataRow> _list = [];
  double _total = 0.0;
  double _stake = 21000.0;
  Map<String, double> _pricesInSEK;
  WalletProvider _wp = new WalletProvider();
  List<CircularStackEntry> _data = [];
  List<Object> _wallets = [];
  AnimatedCircularChart _radialChart;
  TextEditingController _symbolController = new TextEditingController();
  TextEditingController _labelController = new TextEditingController();
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  _getValues() async {
    List<Object> prices = await API.getPrices(currency: 'SEK');
    Map<String, double> _portfolio = _wp.hardcodedList();
    Map<String, double> walletValues = await _wp.getWalletValues();
    _portfolio = mergeMap(_portfolio, walletValues);
    _wallets = await _wp.getWallets();
    _list = [];
      _pricesInSEK = convertPortfolioToSEK(_portfolio, prices);
      _total = prices
        .where((Object coin) => _portfolio.containsKey(coin['symbol']))
        .map((Object coin) => double.parse(coin['price_sek']) * _portfolio[coin['symbol']])
        .reduce((double a, double b) => a + b);
    setState(() {
      List<CircularSegmentEntry> tmp = [];
      _portfolio.forEach((String ticker, double amount) {
        tmp.add(new CircularSegmentEntry(
          _pricesInSEK[ticker], getTickerColor(ticker),
          rankKey: ticker
        ));
        _list.add(new DataRow(cells: <DataCell>[
          new DataCell(new Text(ticker)),
          new DataCell(new Text(_portfolio[ticker].toStringAsFixed(3))),
          new DataCell(new Text(_pricesInSEK[ticker].toStringAsFixed(0) + " SEK")),
        ]));
      });
      _data = [new CircularStackEntry(tmp, rankKey: 'Data Bois')];
      _chartKey.currentState.updateData(_data);
    });
  }

  @override
  void initState() {
    super.initState();
    _radialChart = new AnimatedCircularChart(
      duration: const Duration(milliseconds: 500),
      key: _chartKey,
      size: const Size(280.0, 240.0),
      initialChartData: _data,
      chartType: CircularChartType.Radial,
    );
    _getValues();
  }


  Map<String, double> mergeMap (Map<String, double> mapA, Map<String, double> mapB) {
    Map<String, double> output = mapA;
    mapB.forEach((String symbol, double value) {
      if (output.containsKey(symbol)) {
        output[symbol] += value;
      } else {
        output[symbol] = value;
      }
    });
    return output;
  }

  @override
  Widget build(BuildContext ctx) {
    debugPrint(_wallets.toString());
    return new Scaffold(
      drawer: new Drawer(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Expanded(
              child: new WalletList(wallets: _wallets),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 48.0),
              width: 200.0,
              height: 200.0,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new TextField(
                    controller: _symbolController,
                    decoration: new InputDecoration(labelText: 'Symbol'),
                  ),
                  new TextField(
                    controller: _labelController,
                    decoration: new InputDecoration(labelText: 'Label'),
                  ),
                  new RaisedButton(
                    color: const Color(0xffeeeeee),
                    onPressed: () async {
                      String address = await BarcodeScanner.scan();
                      await _wp.addWallet(
                        _symbolController.text.toUpperCase(),
                        _labelController.text,
                        address,
                      );
                      setState(() {
                        _wallets.add({
                          'symbol': _symbolController.text.toUpperCase(),
                          'label': _labelController.text,
                          'address': address,
                        });
                      });
                    },
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Icon(Icons.add_circle_outline),
                        new Text('Add a wallet')
                      ]
                    ),
                  )
                ],
              )
            )
          ]
        ),
      ),
      body: new Column(
        children: <Widget>[
          headerArc(_total, _stake),
          new Expanded(
            child: new ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                _radialChart,
                new DataTable(
                  sortColumnIndex: 2,
                  sortAscending: false,
                  columns: <DataColumn>[
                    new DataColumn(label: new Text('Currency')),
                    new DataColumn(label: new Text('Amount'), numeric: true),
                    new DataColumn(label: new Text('Value'), numeric: true),
                  ],
                  rows: _list,
                )
              ],
            )
          )
        ],
      ),
      bottomNavigationBar: bottomNav(ctx, 2),
    );
  }
}
