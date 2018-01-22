import 'package:flutter/material.dart';

import '../components/watchlist/watchlist_item.dart';
import '../components/watchlist/watchlist_summary.dart';
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
  int _winners = 0;
  int _losers = 0;
  double _avgChange = 0.0;

  _getList () async {
    _watchlist = await this._wp.getWatchlist();
    _coins = await API.getPrices(filter: _watchlist);
    _winners = _coins.where((Object coin) => double.parse(coin['percent_change_24h']) > 0.0).length;
    _losers = _coins.length - _winners;
    _avgChange = _coins.fold(0.0, (double acc, Object coin) => acc + double.parse(coin['percent_change_24h'])) / _coins.length;
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
          height: 200.0,
          child: new Column(children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.attach_money),
              title: new Text('Add an asset'),
              onTap: () => Navigator.of(ctx).pushNamed('/assets')
            ),
            new ListTile(
              leading: new Icon(Icons.account_balance_wallet),
              title: new Text('Add a wallet'),
              onTap: () => Navigator.of(ctx).pushNamed('/wallets')
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text('Settings'),
              onTap: () => Navigator.of(ctx).pushNamed('/settings')
            )
          ],)
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
        new RefreshIndicator(onRefresh: _getList, child: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              pinned: true,
              
              expandedHeight: 180.0,
              flexibleSpace: new FlexibleSpaceBar(
                background: new Image(
                  image: new NetworkImage('https://ak8.picdn.net/shutterstock/videos/16525018/thumb/9.jpg'),
                  fit: BoxFit.cover,
                ),
                centerTitle: false,
              ),
            ),
            new SliverFixedExtentList(
              itemExtent: 81.5,
              delegate: new SliverChildListDelegate(_list),
            )
          ],
        )
      ),
    );
  }
}