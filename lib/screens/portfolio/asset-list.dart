import 'package:Bitalarm/components/asset-list-item.dart';
import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/screens/coin/coin.screen.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class AssetList extends StatelessWidget {
  final List<AssetEntity> assets;

  AssetList({this.assets});

  Widget build(BuildContext context) {
    var assetsWidgets = assets
        .map((asset) => GestureDetector(
            onTap: () {
              routePush(CoinScreen(
                  coin: Coin(name: asset.name, symbol: asset.symbol)));
            },
            child: AssetListItem(asset: asset)))
        .toList();

    return Wrap(
      children: assetsWidgets,
      alignment: WrapAlignment.start,
      spacing: 30.0,
      runSpacing: 30.0,
      direction: Axis.horizontal,
    );
  }
}
