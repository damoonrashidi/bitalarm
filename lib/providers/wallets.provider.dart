import 'package:flutter/material.dart';

class Wallet {
  final String name;
  final String address;
  final String symbol;

  Wallet({this.name, this.address, this.symbol});
}

class WalletsModel extends ChangeNotifier {
  List<Wallet> list = [];

  WalletsModel();

  addWallet(Wallet wallet) {
    list.add(wallet);
    notifyListeners();
  }

  removeFavorite(Wallet wallet) {
    list.removeWhere((listWallet) => listWallet.name == wallet.name);
    notifyListeners();
  }
}
