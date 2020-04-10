import 'package:Bitalarm/components/coin-list-item.dart';
import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:flutter/material.dart';

class CoinList extends StatelessWidget {
  final List<Coin> coins;

  CoinList({this.coins});

  @override
  Widget build(BuildContext context) {
    var coinList = coins
        .map((coin) => CoinListItem(
              coin: coin,
            ))
        .toList();

    return ListView(
      children: coinList,
      padding: EdgeInsets.all(0),
    );
  }
}
