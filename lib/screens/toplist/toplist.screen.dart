import 'package:Bitalarm/components/coin-list.dart';
import 'package:Bitalarm/components/screen-headline.dart';
import 'package:Bitalarm/components/screen.dart';
import 'package:Bitalarm/components/sort-button.dart';
import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/entities/favorite.entity.dart';
import 'package:Bitalarm/providers/favorites.provider.dart';
import 'package:Bitalarm/services/coin.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopListScreen extends StatefulWidget {
  TopListScreen();

  @override
  State<StatefulWidget> createState() => TopListState();
}

class TopListState extends State<TopListScreen> {
  TopListState();
  List<Coin> _coins = [];
  CoinService _coinService = new CoinService();
  SortProperty sortProperty = SortProperty.PRICE;

  @override
  void initState() {
    super.initState();
    _getCoins();
  }

  void _getCoins() async {
    var coins = await _coinService.getAllPrices();
    setState(() {
      _coins = coins;
    });
  }

  void _sortOnPrice() {
    setState(() {
      _coins.sort((a, b) => b.price.compareTo(a.price));
      sortProperty = SortProperty.PRICE;
    });
  }

  void _sortOnGain(bool ascending) {
    if (ascending) {
      setState(() {
        _coins.sort((b, a) => a.change24h.compareTo(b.change24h));
        sortProperty = SortProperty.GAIN;
      });
    } else {
      setState(() {
        _coins.sort((a, b) => a.change24h.compareTo(b.change24h));
        sortProperty = SortProperty.LOSS;
      });
    }
  }

  void toggleFavorite(Coin coin) {
    final store = Provider.of<FavoritesModel>(context);
    var favorite = FavoriteEntity(name: coin.name, symbol: coin.symbol);
    store.addFavorite(favorite);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      activeNavBar: "toplist",
      child: Padding(
          padding: EdgeInsets.fromLTRB(40, 80, 40, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeadline("TOPLIST"),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SortButton(
                      "Price",
                      onPressed: _sortOnPrice,
                      active: sortProperty == SortProperty.PRICE,
                    ),
                    SortButton(
                      "Gain",
                      onPressed: () {
                        _sortOnGain(true);
                      },
                      active: sortProperty == SortProperty.GAIN,
                    ),
                    SortButton(
                      "Loss",
                      onPressed: () {
                        _sortOnGain(false);
                      },
                      active: sortProperty == SortProperty.LOSS,
                    )
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: CoinList(coins: _coins)),
              ])),
    );
  }
}
