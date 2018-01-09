import 'package:flutter/material.dart';

import '../components/currency_card.dart';
import '../components/bottom_nav.dart';
import '../services/api.dart';
import '../services/watchlist.service.dart';

class WatchlistPage extends StatefulWidget {
  WatchlistPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WatchlistPageState createState() => new _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<GestureDetector> _list = [];
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
      return new GestureDetector(
        onTap: () => Navigator.of(ctx).pushNamed('/details/$ticker'),
        child: new Dismissible(
          key: new Key(coin['symbol']),
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border(
                bottom: new BorderSide(
                  color: const Color(0xffeeeeee),
                  width: 0.5,
                )
              )
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: new Column(
              children: [
                new CurrencyCardTitle(name: name, price: price),
                new CurrencyCardDetails(ticker: ticker, change: change),
              ]
            )
          )
        )
      );
    });
    return new Scaffold(
      backgroundColor: const Color(0xffeeeeee),
      bottomNavigationBar: new AppBotNav(currentIndex: 0),
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