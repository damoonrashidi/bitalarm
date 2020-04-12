import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Wallet {
  final String name;
  final String address;
  final String symbol;

  Wallet({this.name, this.address, this.symbol});
}

class WalletsModel extends ChangeNotifier {
  List<Wallet> wallets = [];
  List<AssetEntity> assets = [];
  var assetBox = Hive.box('assets');
  var walletBox = Hive.box('wallets');

  WalletsModel();

  addWallet(Wallet wallet) {
    wallets.add(wallet);
    walletBox.add(wallet);
    notifyListeners();
  }

  removeWallet(Wallet wallet) {
    wallets.removeWhere((listWallet) => listWallet.name == wallet.name);
    walletBox.delete(wallet);
    notifyListeners();
  }

  /// Asset related things
  /// since assets and wallets have the same use (calculate holdings)
  /// i put them in the same store. This means all the code is duplicated here, but it also means
  /// that i only have to inject one provider in the components that care about wallet/asset
  /// related things.

  addAsset(AssetEntity asset) {
    assets.add(asset);
    assetBox.add(asset);
    notifyListeners();
  }

  removeAsset(AssetEntity asset) {
    assets.removeWhere((listAsset) => listAsset.name == asset.name);
    assetBox.delete(asset);
    notifyListeners();
  }
}
