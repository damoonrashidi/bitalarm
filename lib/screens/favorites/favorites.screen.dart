import 'package:Bitalarm/components/coin-list.dart';
import 'package:Bitalarm/components/screen-headline.dart';
import 'package:Bitalarm/components/screen.dart';
import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/providers/favorites.provider.dart';
import 'package:Bitalarm/services/coin.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  CoinService coinService = CoinService();
  List<Coin> _favs = [];

  @override
  void initState() {
    super.initState();
  }

  didChangeDependencies() async {
    super.didChangeDependencies();
    final store = Provider.of<FavoritesModel>(context).list;
    var favoriteSymbols = store.map((coin) => coin.symbol).toList();
    var favs = await coinService.getPriceForSymbols(favoriteSymbols);
    setState(() {
      _favs = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        activeNavBar: "favorites",
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScreenHeadline("FAVORITES"),
              Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: CoinList(coins: _favs)),
            ]));
  }
}
