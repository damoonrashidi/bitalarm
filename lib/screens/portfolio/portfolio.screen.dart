import 'package:Bitalarm/components/screen-scaffold.dart';
import 'package:Bitalarm/screens/portfolio/add-asset/add-asset.screen.dart';
import 'package:Bitalarm/screens/portfolio/asset-list.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class PortfolioScreen extends StatelessWidget {
  _addAsset() {
    routePush(AddAssetScreen(), RouterType.material);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: "portfolio",
        activeNavBar: "portfolio",
        fab: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _addAsset,
        ),
        children: [
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [AssetList()])
          ])),
        ]);
  }
}
