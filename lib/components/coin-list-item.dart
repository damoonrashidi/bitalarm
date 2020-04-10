import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/entities/favorite.entity.dart';
import 'package:Bitalarm/providers/favorites.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;

  final TextStyle symbolStyle =
      const TextStyle(fontSize: 14, fontFamily: "Oswald", height: 1);
  final TextStyle nameStyle =
      const TextStyle(fontSize: 18, fontFamily: "Oswald", height: 2);

  CoinListItem({this.coin});

  _addToFavorites(BuildContext context) {
    var store = Provider.of<FavoritesModel>(context, listen: false);
    var favorite = FavoriteEntity(name: coin.name, symbol: coin.symbol);
    store.addFavorite(favorite);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    _addToFavorites(context);
                  },
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(coin.symbol, style: symbolStyle),
                  Text(coin.name, style: nameStyle)
                ])
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("\$${coin.price.toStringAsFixed(2)}"),
                Text("${coin.change24h.toStringAsFixed(2)}%")
              ]),
            ]));
  }
}
