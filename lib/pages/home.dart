import 'package:flutter/material.dart';

import '../components/currency_card.dart';
import '../components/bottom_nav.dart';
import '../helpers/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Card> _list = [];
  List<String> _watchlist = [];
  List<Object> _coins = [];
  WatchlistProvider _wp = new WatchlistProvider();

  _getList () async {
    _watchlist = await this._wp.getWatchlist();
    _coins = await API.getPrices(filter: _watchlist);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext ctx) {
    _list = new List.generate(_watchlist.length, (int index) {
      Object coin = _coins.firstWhere((Object needle) => needle['symbol'] == _watchlist[index]);
      double change = double.parse(coin['percent_change_24h']);
      double price = double.parse(coin['price_usd']);
      String ticker = coin['symbol'];
      String name = coin['name'];
      return new Card(
        child: new Container(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: new Column(
            children: [
              currencyCardTitle(name, price),
              currencyCardDetails(ticker, change),
            ]
          )
        )
      );
    });
    return new Scaffold(
      bottomNavigationBar: bottomNav(ctx, 0),
      body: new RefreshIndicator(
        onRefresh: _getList,
        child: new ListView(
          children: _list,
        ),
      ),
    );
  }
}
