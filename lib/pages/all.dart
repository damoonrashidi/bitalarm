import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../components.dart';
import '../helpers/services.dart';


class AllCurrenciesPage extends StatefulWidget {
  AllCurrenciesPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AllCurrenciesState createState() => new _AllCurrenciesState();
}

class _AllCurrenciesState extends State<AllCurrenciesPage> {
  Map<String, Object> _prices = {};
  List<Card> list = [];
  List<String> watchlist = [];
  WatchlistProvider watchProvider = new WatchlistProvider();

  _refreshValue() async {
    list = [];
    watchlist = await watchProvider.getWatchlist();
    var data = JSON.decode((await http.get('https://api.coinmarketcap.com/v1/ticker/')).body);
    for (var currency in data) {
      _prices[currency['symbol']] = currency;
    }
    _prices.forEach((String ticker, Object data) {
      list.add(currencyCard(
        data['symbol'],
        data['name'],
        double.parse(data['price_usd']),
        double.parse(data['percent_change_24h']),
        true,
        watchlist,
      ));
    });
    setState((){});
  }

  _AllCurrenciesState () {
    _refreshValue();
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      drawer: sidebarDrawer(_prices),
      bottomNavigationBar: bottomNav(ctx, 1),
      body: new Container(
        padding: new EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
        child: new ListView(
          children: list,
        ),
      ),
    );
  }
}
