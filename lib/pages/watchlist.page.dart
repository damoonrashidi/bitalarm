import 'package:flutter/material.dart';

import '../components/watchlist/watchlist_item.dart';
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
  List<WatchlistItem> _list = [];
  List<String> _watchlist = [];
  List<Object> _coins = [];
  WatchlistService _wp = new WatchlistService();

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
      String symbol = coin['symbol'];
      String name = coin['name'];
      return new WatchlistItem(price: price, name: name, symbol: symbol, percentChange: change);
    });
    return new Scaffold(
      bottomNavigationBar: new AppBotNav(currentIndex: 0),
      drawer: new Drawer(child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [new Container(
          height: 80.0,
          child: new Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: new ListTile(
              onTap: () => Navigator.pushNamed(ctx, '/settings'),
              leading: const Icon(Icons.settings),
              title: new Text('Settings'),
            )
          )
        )],
      )),
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