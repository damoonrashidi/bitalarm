import 'package:flutter/material.dart';
import '../styles.dart';

class CurrencyCardDetails extends StatelessWidget {
  final String name;
  final String symbol;
  final double percentChange;
  final double price;
  CurrencyCardDetails({this.name, this.price, this.symbol, this.percentChange});

  @override
  Widget build(BuildContext ctx) {
    bool trendUp = this.percentChange > 0.0;
    return new Column(children: [
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(name, style: headlineTextStyle, overflow: TextOverflow.ellipsis),
          new Row(children: [
            const Icon(Icons.attach_money),
            new Text(price.toString(), style: headlineTextStyle, overflow: TextOverflow.ellipsis)   
          ])
        ]
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(symbol,
            overflow: TextOverflow.fade,
            style: new TextStyle(color: trendUp ? Colors.grey : Colors.red,fontWeight: FontWeight.w800)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(percentChange.toString() + "%", style: percentChangeStyle),
              new Icon(trendUp ? Icons.arrow_upward : Icons.arrow_downward, color: trendUp ? Colors.blue : Colors.red),
            ],
          )
        ]
      )
    ]);
  }
}
