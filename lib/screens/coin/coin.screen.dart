import 'package:Bitalarm/components/order-book.dart';
import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/providers/favorites.provider.dart';
import 'package:Bitalarm/screens/coin/coin-header.dart';
import 'package:Bitalarm/services/coin.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinScreen extends StatefulWidget {
  final Coin coin;

  CoinScreen({this.coin});

  @override
  State<StatefulWidget> createState() => CoinScreenState();
}

class CoinScreenState extends State<CoinScreen> {
  CoinService coinService = CoinService();
  bool _isFavorite = false;
  List<double> _historicalPriceData = [];

  @override
  void initState() {
    _getCoinData();
    super.initState();
  }

  _getCoinData() async {
    List<double> data =
        await coinService.getHistoricalCoinData(widget.coin.symbol);
    setState(() {
      _historicalPriceData = data;
    });
  }

  didChangeDependencies() async {
    super.didChangeDependencies();
    final store = Provider.of<FavoritesModel>(context);
    setState(() {
      _isFavorite = store.isFavorite(widget.coin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image(
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width + 100,
        height: MediaQuery.of(context).size.height,
        image: AssetImage('assets/images/dark-page-background.png'),
      ),
      CustomScrollView(slivers: [
        CoinHeader(
            coin: widget.coin,
            isFavorite: _isFavorite,
            priceData: _historicalPriceData),
        SliverList(
          delegate: SliverChildListDelegate([OrderBook(coin: widget.coin)]),
        )
      ]),
    ]));
  }
}
