import 'package:flutter/material.dart';
import '../styles.dart';

class CurrencyCardTitle extends StatelessWidget {
  final String name;
  final double price;
  CurrencyCardTitle({this.name, this.price});

  @override
  Widget build(BuildContext ctx) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(name, style: headlineTextStyle, overflow: TextOverflow.ellipsis),
        new Row(children: [
          const Icon(Icons.attach_money),
          new Text(price.toString(), style: headlineTextStyle, overflow: TextOverflow.ellipsis)   
        ])
      ]
    );
  }
}

class CurrencyCardDetails extends StatelessWidget {
  final String ticker;
  final double change;
  CurrencyCardDetails({this.ticker, this.change});

  @override
  Widget build(BuildContext ctx) {
    bool trendUp = this.change > 0.0;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(ticker,
          overflow: TextOverflow.fade,
          style: new TextStyle(
            color: trendUp ? Colors.grey : Colors.red,
            fontWeight: FontWeight.w800)),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(change.toString() + "%", style: percentChangeStyle),
            new Icon(trendUp ? Icons.arrow_upward : Icons.arrow_downward,
              color: trendUp ? Colors.blue : Colors.red),
          ],
        ),
      ],
    );
  }
}
