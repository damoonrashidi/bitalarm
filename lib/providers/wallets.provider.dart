import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/entities/wallet.entity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WalletsModel extends ChangeNotifier {
  List<WalletEntity> wallets = [];
  List<AssetEntity> assets = [];
  var assetBox = Hive.box<AssetEntity>('assets');
  var walletBox = Hive.box<WalletEntity>('wallets');

  WalletsModel() {
    wallets = walletBox.values.toList();
    assets = assetBox.values.toList();
    notifyListeners();
  }

  addWallet(WalletEntity wallet) {
    wallets.add(wallet);
    walletBox.add(wallet);
    notifyListeners();
  }

  removeWallet(WalletEntity wallet) {
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
