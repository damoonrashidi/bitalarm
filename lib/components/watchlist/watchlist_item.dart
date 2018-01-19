import 'package:flutter/material.dart';
import '../currency_card.dart';
import '../../services/watchlist.service.dart';

class WatchlistItem extends StatefulWidget {

  final String symbol;
  final String name;
  final double price;
  final double percentChange;
  final bool watched;

  WatchlistItem({
    this.name,
    this.price,
    this.symbol,
    this.watched,
    this.percentChange,
  });


  @override
  createState() => new WatchlistItemState(
    percentChange: percentChange,
    name: name,
    symbol: symbol,
    watched: watched,
    price: price,
  );
}

class WatchlistItemState extends State<WatchlistItem> {

  final String symbol;
  final String name;
  final double price;
  final double percentChange;
  final bool watched;
  bool trendUp;
  WatchlistService _wp = new WatchlistService();

  WatchlistItemState({
    this.name,
    this.price,
    this.symbol,
    this.watched,
    this.percentChange,
  }) {
    this.trendUp = percentChange > 0;
  }

  @override
  Widget build(BuildContext ctx) {
    return new GestureDetector(
      onTap: () => Navigator.of(ctx).pushNamed('/details/$symbol'),
      child: new Dismissible(
        direction: DismissDirection.startToEnd,
        background: new Container(
          alignment: Alignment.centerLeft,
          color: Colors.red,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: const Icon(Icons.favorite_border, color: Colors.white),
          ),
        ),
        onDismissed: (DismissDirection direction) {
          _wp.removeFromWatchlist(symbol);
          Scaffold.of(ctx).showSnackBar(new SnackBar(
            content: new Text('Removed from watchlist!'),
          ));
        },
        key: new Key(this.symbol),
        child: new Container(
          decoration: new BoxDecoration(
            color: Theme.of(ctx).backgroundColor,
            border: new Border(
              bottom: new BorderSide(
                color: const Color(0xffeeeeee),
                width: 0.5,
              )
            )
          ),
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: new CurrencyCardDetails(symbol: symbol, percentChange: percentChange, name: name, price: price)
        )
      )
    );
  }
}