import 'package:Bitalarm/components/coin-list-item.dart';
import 'package:Bitalarm/components/screen-scaffold.dart';
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
  ScrollController listController = ScrollController();

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

  void _onSort(SortProperty prop) {
    setState(() {
      sortProperty = prop;
      switch (prop) {
        case SortProperty.PRICE:
          _coins.sort((b, a) => a.price.compareTo(b.price));
          break;
        case SortProperty.GAIN:
          _coins.sort((b, a) => a.change24h.compareTo(b.change24h));
          break;
        case SortProperty.LOSS:
          _coins.sort((a, b) => a.change24h.compareTo(b.change24h));
          break;
      }
    });
  }

  void toggleFavorite(Coin coin) {
    final store = Provider.of<FavoritesModel>(context);
    var favorite = FavoriteEntity(name: coin.name, symbol: coin.symbol);
    store.addFavorite(favorite);
  }

  @override
  Widget build(BuildContext context) {
    var coinWidgets = _coins
        .map((coin) => Padding(
            padding: EdgeInsets.fromLTRB(48, 8, 48, 8),
            child: CoinListItem(coin: coin)))
        .toList();

    return ScreenScaffold(title: "toplist", activeNavBar: "toplist", children: [
      SliverToBoxAdapter(
        child: SortButtonGroup(onSort: _onSort, active: sortProperty),
      ),
      SliverList(delegate: SliverChildListDelegate(coinWidgets))
    ]);
  }
}
