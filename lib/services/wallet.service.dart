import 'dart:async';
import 'dart:io';

import '../services/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WalletService {
  Database db;
  
  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coinwatch.db");
    this.db = await openDatabase(path, version: 1, onOpen: (Database db) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS wallet (
          id INTEGER PRIMARY KEY,
          symbol TEXT,
          label TEXT,
          address TEXT UNIQUE
        );''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS asset (
          id INTEGER PRIMARY KEY,
          symbol TEXT,
          amount REAL
        );
      ''');
    });
  }

  Future close() async => this.db.close();

  Future<List<Map<String, String>>> getWallets({String symbol = ''}) async {
    await this.open();
    List<Map<String, String>> wallets;
    if (symbol == '') {
      wallets = await db.query('wallet', distinct: true);
    } else {
      wallets = await db.query('wallet', where: 'symbol = ?', whereArgs: [symbol], distinct: true);
    }
    this.close();
    return wallets;
  }

  Stream<Object> getWalletValues() async* {
    List<Map<String, String>> wallets = await this.getWallets();
    for (int i = 0; i < wallets.length; i++) {
      String symbol = wallets[i]['symbol'];
      String address = wallets[i]['address'];
      switch (symbol) {
        case 'DASH':
        case 'LTC':
        case 'BCH':
        case 'BTC':
          double value = await API.getGenericWalletValue(symbol, address);
          yield {'symbol': symbol, 'amount': value, 'value': 0.0};
          break;
        case 'ADA':
          double value = await API.getADAWalletValue(address);
          yield {'symbol': symbol, 'amount': value, 'value': 0.0};
          break;
        case 'ETH':
          Map<String, double> values = await API.getETHWalletValue(address);
          for(int j = 0; j < values.keys.length; j++) {
            String token = values.keys.toList()[j];
            double amount = values[token];
            yield {'symbol': token, 'amount': amount, 'value': 0.0};
          }
          break;
      }
    }
  }

  Future<List<Map>> coinsToPrice({List<Object> coins: const [], String currency: 'USD'}) async {
    currency = currency.toLowerCase();
    List<Object> prices = await API.getPrices(currency: currency);
    List<Object> list = [];
    coins.forEach((Object coin) {
      Map price = prices.firstWhere((test) => test['symbol'] == coin['symbol'], orElse: () => {'price_$currency': "0.0"});
      list.add({
        'symbol': coin['symbol'],
        'amount': coin['amount'],
        'value' : double.parse(price['price_$currency']) * coin['amount'].toDouble(),
      });
    });
    return list;
  }

  Future<int> addWallet(String symbol, String label, String address) async {
    await this.open();
    if(address.contains(':')) {
      address = address.split(':')[1];
    }
    int val = await this.db.rawInsert("INSERT INTO wallet (symbol, label, address) VALUES ('$symbol', '$label', '$address')");
    this.close();
    return val;
  }

  Future<int> addAsset(String symbol, double amount) async {
    await this.open();
    int val = await this.db.rawInsert("INSERT INTO asset (symbol, amount) VALUES ('${symbol.toUpperCase()}', '$amount')");
    this.close();
    return val;
  }

  Future<int> removeAsset(int id) async {
    await this.open();
    int val = await this.db.delete('asset', where: 'id = ?', whereArgs: [id]);
    this.close();
    return val;
  }

  Future<List<Object>> getAssets() async {
    await this.open();
    List<Map<String, double>> res = await this.db.query('asset');
    List<Map<String, dynamic>> assets = res.map((Map<String, dynamic> r) => {
      'symbol': r['symbol'],
      'amount': r['amount'],
      'id':     r['id'],
      'value':  0.0,
    }).toList();
    this.close();
    return assets;
  }

  Future<int> removeWallet(String address) async {
    await this.open();
    int val = await this.db.delete('wallet', where: 'address = ?', whereArgs: [address]);
    this.close();
    return val;
  }
}
