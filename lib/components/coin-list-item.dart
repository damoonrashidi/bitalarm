import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/entities/favorite.entity.dart';
import 'package:Bitalarm/providers/favorites.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

final TextStyle symbolStyle =
    const TextStyle(fontSize: 14, fontFamily: "Oswald", height: 1);

final TextStyle nameStyle =
    const TextStyle(fontSize: 18, fontFamily: "Oswald", height: 2);

class CoinListItem extends StatefulWidget {
  final Coin coin;

  CoinListItem({this.coin});

  @override
  _CoinListItemState createState() => _CoinListItemState();
}

class _CoinListItemState extends State<CoinListItem> {
  bool isFavorite = false;

  _toggleFavorite(BuildContext context) {
    var store = Provider.of<FavoritesModel>(context, listen: false);
    var favorite =
        FavoriteEntity(name: widget.coin.name, symbol: widget.coin.symbol);
    store.toggleFavorite(favorite);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var store = Provider.of<FavoritesModel>(context);
    isFavorite = store.isFavorite(widget.coin);
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
                  icon:
                      Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    _toggleFavorite(context);
                  },
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.coin.symbol, style: symbolStyle),
                  Text(widget.coin.name, style: nameStyle)
                ])
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("\$${widget.coin.price.toStringAsFixed(2)}"),
                Text("${widget.coin.change24h.toStringAsFixed(2)}%")
              ]),
            ]));
  }
}
