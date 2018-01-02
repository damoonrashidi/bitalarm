import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WalletProvider {
  Database db;
  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coinwatch.db");
    this.db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS watchlist (id INTEGER PRIMARY KEY, symbol TEXT UNIQUE);
        CREATE TABLE IF NOT EXISTS wallet (id INTEGER PRIMARY KEY, symbol TEXT, address TEXT UNIQUE);
        INSERT INTO watchlist (symbol) VALUES ('ETH'), ('BCH'), ('DASH'), ('LTC'), ('ADA'), ('EOS');
        INSERT INTO wallet (symbol, address) VALUES ('ETH', '0x3CcD96131c233ceC261f9Be610020939FDC7863E'), ('ETH', '0x42E1F7d6b18b0e51e9B4Ae214BEcCb99eCC24b82');
      ''');
    });
  }

  Map<String, double> hardcodedList() {
    return {
      'ETH': 2.091987833659823383 + 0.91188038,
      'EOS': 23.052502212272,
      'REQ': 500.0,
      'REP': 2.2025932637997,
      'SALT': 10.62236917,
      'OMG': 5.41910301,
      'RDN': 0.96800000,
      'XMR': 0.17282700,
      'ADA': 164.834,
      'BCH': 0.23066664,
      'BTC': 0.0248,
      'DASH': 0.39607621,
      'LTC': 1.7670664,
    };
  }

  Future close() async => this.db.close();

  Future<List<Map<String, String>>> getWallets() async {
    await this.open();
    List<Map<String, String>> wallets = await db.query('wallet', distinct: true);
    this.close();
    return wallets;
  }

  Future<double> getWalletValues() async {
    List<Map<String, String>> wallets = await this.getWallets();
    List<String> addresses = wallets.map((wallet) => wallet['address']).toList();
    double eth = 0.0;
    addresses.forEach((address) async {
      double balance = (await API.getETHWalletValue(address))['ETH']['balance'];
      eth += balance;
    });
    return eth;
  }

  Future<int> addWallet(String symbol, String address) async {
    await this.open();
    int val = await this.db.insert('wallet', {symbol: symbol, address: address});
    this.close();
    return val;
  }

  Future<int> removeWallet(String address) async {
    await this.open();
    int val = await this.db.delete('wallet', where: 'address = ?', whereArgs: [address]);
    this.close();
    return val;
  }
}
