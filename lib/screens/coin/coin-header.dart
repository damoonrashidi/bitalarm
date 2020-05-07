import 'dart:math';

import 'package:Bitalarm/components/screen-headline.dart';
import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/entities/favorite.entity.dart';
import 'package:Bitalarm/providers/favorites.provider.dart';
import 'package:Bitalarm/screens/coin/coin-graph-labels.dart';
import 'package:Bitalarm/screens/coin/coin-graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CoinHeader extends StatelessWidget {
  final Coin coin;
  final List<double> priceData;
  final bool isFavorite;

  CoinHeader({this.coin, this.isFavorite, this.priceData = const []});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CoinHeaderDelegate(
          coin: coin,
          isFavorite: isFavorite,
          minExtent: 100,
          maxExtent: 220,
          priceData: priceData),
    );
  }
}

class CoinHeaderDelegate implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Coin coin;
  final List<double> priceData;
  final bool isFavorite;

  CoinHeaderDelegate({
    this.minExtent,
    @required this.maxExtent,
    this.coin,
    this.priceData = const [],
    this.isFavorite,
  });

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  _getOpacityForOffset(double shrinkOffset) {
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
  }

  _toggleFavorite(BuildContext context) {
    var store = Provider.of<FavoritesModel>(context, listen: false);
    var favorite = FavoriteEntity(symbol: coin.symbol, name: coin.name);
    store.toggleFavorite(favorite);
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacity = _getOpacityForOffset(shrinkOffset);
    return Stack(fit: StackFit.expand, children: [
      ScreenHeadline(coin.name, opacity: opacity),
      Padding(
          padding: EdgeInsets.only(
            top: 80,
            bottom: 40,
          ),
          child: Stack(fit: StackFit.expand, children: [
            CoinGraph(data: priceData),
            CoinGraphLabels(data: priceData),
          ])),
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 48),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                color: Colors.white,
                onPressed: Navigator.of(context).pop,
                icon: Icon(Icons.arrow_back),
              ),
              IconButton(
                color: Colors.red,
                onPressed: () {
                  _toggleFavorite(context);
                },
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              ),
            ]),
      ),
    ]);
  }
}
