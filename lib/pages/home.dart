import 'package:flutter/material.dart';

import '../components/currency_card.dart';
import '../components/bottom_nav.dart';
import '../services/api.dart';
import '../services/watchlist.service.dart';
import '../services/wallet.service.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Container> _list = [];
  List<String> _watchlist = [];
  List<Object> _coins = [];
  WatchlistProvider _wp = new WatchlistProvider();
  WalletProvider _walletProvider = new WalletProvider();

  _getList () async {
    Map<String, double> wallets = await _walletProvider.getWalletValues();
    debugPrint(wallets.toString());
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
      return new Container(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: new GestureDetector(
          onTap: () => Navigator.of(ctx).pushNamed('/details/$ticker'),
          child: new Card(
            child: new Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: new Column(
                children: [
                  new CurrencyCardTitle(name: name, price: price),
                  new CurrencyCardDetails(ticker: ticker, change: change),
                ]
              )
            )
          )
        )
      );
    });
    return new Scaffold(
      bottomNavigationBar: bottomNav(ctx, 0),
      body: _list.length == 0 ? 
        new Center(child: new Text(
          'Add coins to your watchlist from the All tab',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22.0,
            color: const Color(0xffaaaaaa),
          ),
        )) :
        new RefreshIndicator(onRefresh: _getList, child: new ListView(children: _list)),
    );
  }
}
