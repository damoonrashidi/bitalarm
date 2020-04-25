import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/screens/coin/coin.screen.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

var nameStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    height: 3,
    fontWeight: FontWeight.bold,
    fontFamily: "Oswald");

var symbolStyle = TextStyle(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.w200,
    fontFamily: "Oswald");

var priceStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    height: 3,
    fontWeight: FontWeight.w200,
    fontFamily: "Oswald");

TextStyle percentStyle(double percent) {
  if (percent < 0) {
    return TextStyle(
        color: Color.fromRGBO(248, 115, 115, 1.00),
        fontSize: 14,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w200,
        fontFamily: "Oswald");
  }
  return TextStyle(
      color: Color.fromRGBO(173, 115, 248, 1.00),
      fontSize: 14,
      fontWeight: FontWeight.w200,
      fontFamily: "Oswald");
}

class CoinListItem extends StatelessWidget {
  final Coin coin;

  CoinListItem({this.coin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          routePush(CoinScreen(coin: coin), RouterType.fade);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  coin.name.toUpperCase(),
                  style: nameStyle,
                ),
                Text(coin.symbol)
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("\$" + coin.price.toStringAsFixed(2), style: priceStyle),
                Text(coin.change24h.toStringAsFixed(2) + "%",
                    style: percentStyle(coin.change24h))
              ]),
            ]));
  }
}
