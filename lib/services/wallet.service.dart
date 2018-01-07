import 'dart:async';
import 'dart:io';

import '../services/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WalletProvider {
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

  Future<List<Object>> getWalletValues() async {
    List<Map<String, String>> wallets = await this.getWallets();
    Map<String, double> tokens = {};
    List<Object> list = [];
    await Future.forEach(wallets, (wallet) async {
      switch (wallet['symbol']) {
        case 'ETH':  
          Map<String, double> values = await API.getETHWalletValue(wallet['address']);
          values.forEach((String symbol, double value) {
            if(tokens.containsKey(symbol)) {
              tokens[symbol] += value;
            } else {
              tokens[symbol] = value;
            }
          });
          break;
        case 'DASH':
        case 'LTC':
        case 'BCH':
        case 'BTC':
          double value = await API.getGenericWalletValue(wallet['symbol'], wallet['address']);
          if(tokens.containsKey(wallet['symbol'])) {
            tokens[wallet['symbol']] += value;
          } else {
            tokens[wallet['symbol']] = value;
          }
          break;
        case 'ADA':
          double value = await API.getADAWalletValue(wallet['address']);
          if(tokens.containsKey(wallet['symbol'])) {
            tokens[wallet['symbol']] += value;
          } else {
            tokens[wallet['symbol']] = value;
          }
          break;
      }
    });
    tokens.forEach((String symbol, double amount) {
      list.add({
        'symbol': symbol,
        'amount': amount,
        'value': 0.0,
      });
    });
    return list;
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

  Future<int> removeWallet(String address) async {
    await this.open();
    int val = await this.db.delete('wallet', where: 'address = ?', whereArgs: [address]);
    this.close();
    return val;
  }
}
