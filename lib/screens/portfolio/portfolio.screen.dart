import 'package:Bitalarm/components/add-wallet-button.dart';
import 'package:Bitalarm/components/donut-chart.dart';
import 'package:Bitalarm/components/screen-scaffold.dart';
import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:Bitalarm/screens/portfolio/asset-list.dart';
import 'package:Bitalarm/services/coin.service.dart';
import 'package:Bitalarm/services/wallet.service.dart';
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
  Map<String, Color> colors = Map();

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
    assets = Provider.of<WalletsModel>(context)
        .assets
        .map((asset) => asset)
        .toList();
    assetData.clear();
    assets.forEach((asset) {
      assetData[asset.symbol] = asset.amount;
      setState(() {});
    });
    setState(() {});
    _getWalletData();
    _setColors();
    super.didChangeDependencies();
  }

  @override
  dispose() {
    assets = [];
    assetData.clear();
    super.dispose();
  }

  _setColors() async {
    assets.forEach((asset) async {
      var nameSum = asset.name
              .split('')
              .map((char) => char.codeUnitAt(0))
              .reduce((value, element) => value + element) *
          100000;
      nameSum.toRadixString(16);
      Color color = Color(nameSum).withOpacity(1);
      colors[asset.symbol] = color;
    });
    setState(() {});
  }

  _getWalletData() async {
    var wallets = Provider.of<WalletsModel>(context, listen: false).wallets;
    var walletService = WalletService();
    await for (var asset in walletService.getWalletValues(wallets)) {
      int index = assets.indexWhere((needle) => needle.symbol == asset.symbol);
      if (index != -1) {
        assets[index].amount += asset.amount;
      } else {
        assets.add(asset);
      }

      assetData.update(asset.symbol, (value) => value + asset.amount,
          ifAbsent: () => asset.amount);

      _setColors();

      setState(() {});
    }
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
                  DonutChart(
                    data: assetData,
                    prices: prices,
                    colors: colors,
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: AddWalletButton()),
                  AssetList(assets: assets),
                ])
          ])),
        ]);
  }
}
