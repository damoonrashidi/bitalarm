import 'package:Bitalarm/components/add-wallet-button.dart';
import 'package:Bitalarm/components/donut-chart.dart';
import 'package:Bitalarm/components/screen-scaffold.dart';
import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:Bitalarm/screens/portfolio/asset-list.dart';
import 'package:Bitalarm/services/coin.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioScreen extends StatefulWidget {
  PortfolioScreen();

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<AssetEntity> assets = [];
  Map<String, double> prices = Map();
  Map<String, double> assetData = Map();

  @override
  initState() {
    super.initState();
    _setPrices();
  }

  _setPrices() async {
    var service = CoinService();
    var coins = await service.getAllPrices();
    coins.forEach((coin) {
      prices[coin.symbol] = coin.price;
    });
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    assets = Provider.of<WalletsModel>(context).assets;
    assetData = Map();
    assets.forEach((asset) {
      assetData[asset.symbol] = asset.amount;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: "portfolio",
        activeNavBar: "portfolio",
        children: [
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DonutChart(data: assetData, prices: prices),
                  Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: AddWalletButton()),
                  AssetList(assets: assets)
                ])
          ])),
        ]);
  }
}
