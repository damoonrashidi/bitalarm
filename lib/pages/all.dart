import 'dart:async';
import 'package:flutter/material.dart';
import '../components.dart';
import '../helpers/services.dart';


class AllCurrenciesPage extends StatefulWidget {
  AllCurrenciesPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AllCurrenciesState createState() => new _AllCurrenciesState();
}

enum SortOrder { marketCap, trending, losing }

class _AllCurrenciesState extends State<AllCurrenciesPage> with SingleTickerProviderStateMixin {
  Map<String, Object> _prices = {};
  List<Card> _list = [];
  List<String> _watchlist = [];
  WatchlistProvider watchProvider = new WatchlistProvider();
  SortOrder _sortOrder = SortOrder.marketCap;

  _refreshValue() async {
    _list = [];
    _prices = {};
    _watchlist = await watchProvider.getWatchlist();
    List<Object> data = await API.getPrices();
    if (_sortOrder == SortOrder.trending) {
      data.sort((Object a, Object b) => double.parse(a['percent_change_24h']) > double.parse(b['percent_change_24h']) ? -1 : 1);
    } else if (_sortOrder == SortOrder.losing) {
      data.sort((Object a, Object b) => double.parse(a['percent_change_24h']) > double.parse(b['percent_change_24h']) ? 1 : -1);
    }
    for (var currency in data) {
      _prices[currency['symbol']] = currency;
    }
    _prices.forEach((String ticker, Object data) {
      _list.add(currencyCard(
        data['symbol'],
        data['name'],
        double.parse(data['price_usd']),
        double.parse(data['percent_change_24h']),
        true,
        _watchlist,
      ));
    });
    setState((){});
  }

  void setSortOrder({SortOrder order = SortOrder.marketCap}) {
    _sortOrder = order;
    _refreshValue();
  }


  @override
  void initState() {
    super.initState();
    _refreshValue();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      bottomNavigationBar: bottomNav(ctx, 1),
      drawer: new Drawer(
        child: new Container(
          margin: const EdgeInsets.only(top: 48.0, bottom: 20.0),
          child: new Column(
            children: [
              new ListTile(
                leading: new Icon(Icons.public),
                title: new Text('Market cap'),
                onTap: () => this.setSortOrder(order: SortOrder.marketCap)
              ),
              new ListTile(
                leading: new Icon(Icons.trending_up),
                title: new Text('Trending up'),
                onTap: () => this.setSortOrder(order: SortOrder.trending)
              ),
              new ListTile(
                leading: new Icon(Icons.trending_down),
                title: new Text('Trending down'),
                onTap: () => this.setSortOrder(order: SortOrder.losing)
              ),
            ],
          ),
        )
      ),
      body: new Container(
        padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: new ListView(
          children: _list,
        ),
      ),
    );
  }
}
