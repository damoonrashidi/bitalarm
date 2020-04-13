import 'package:Bitalarm/components/coin-list-item.dart';
import 'package:Bitalarm/components/screen-scaffold.dart';
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
  List<Coin> _favorites = [];

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
      _favorites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    var coinWidgets = _favorites
        .map((coin) => Padding(
            padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: CoinListItem(coin: coin)))
        .toList();

    return ScreenScaffold(
      title: "favorites",
      activeNavBar: "favorites",
      children: [
        SliverList(
          delegate: SliverChildListDelegate(coinWidgets),
        )
      ],
    );
  }
}
