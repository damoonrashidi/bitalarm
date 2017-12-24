import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../components.dart';

class Token {
  String address;
  int decimals;
  String description;
  int holdersCount;
  int issuancesCount;
  int lastUpdated;
  String name;
  String owner;
  Map<String, dynamic> price;
  String symbol;
  int totalIn;
  int totalOut;
  String totalSupply;
}

class Coin {
  String id;
  String name;
  String symbol;
  String rank;
  String price_usd;
  String price_btc;
  String 24h_volume_usd;
  String market_cap_usd;
  String available_supply;
  String total_supply;
  String max_supply;
  String percent_change_1h;
  String percent_change_24h;
  String percent_change_7d;
  String last_updated;

  String toString() => '';
}

class API {

  static Future<Map> getETHWalletValue (String address) async {
    String ethplorer = 'https://api.ethplorer.io/getAddressInfo/$address?apiKey=freekey';
    try {
      return await JSON.decode((await http.get(ethplorer)).body);
    } catch (e) {
      return {'ETH': {
        'balance': 0.0
      }};
    }
  }

  static Future<List<Object>> getPrices ({List<String> filter = const [], String currency = 'USD'}) async {
    List<Object> list = JSON.decode((await http.get('https://api.coinmarketcap.com/v1/ticker/?convert=$currency')).body);
    if (filter.length == 0) {
      return list;
    } else {
      return list.where((Object coin) => filter.indexOf(coin['symbol']) >= 0).toList();
    }
  }

  static Future<List<Card>> getPricesCards () async {
    List<Object> coins = await API.getPrices();
    return coins.map((Object coin) => currencyCard(
      coin['symbol'],
      coin['name'],
      double.parse(coin['price_usd']),
      double.parse(coin['percent_change_24h']),
    )).toList();
  }

}

class WalletProvider {
  Database db;
  
  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coinwatch.db");
    this.db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS watchlist (id INTEGER PRIMARY KEY, symbol TEXT UNIQUE);
        CREATE TABLE IF NOT EXISTS wallet (id INTEGER PRIMARY KEY, symbol TEXT, address TEXT UNIQUE);
        INSERT INTO watchlist (symbol) VALUES ('ETH'), ('BCH'), ('DASH'), ('LTC'), ('ADA'), ('EOS');
        INSERT INTO wallet (symbol, address) VALUES ('ETH', '0x3CcD96131c233ceC261f9Be610020939FDC7863E'), ('ETH', '0x42E1F7d6b18b0e51e9B4Ae214BEcCb99eCC24b82');
      ''');
    });
  }

  Map<String, double> hardcodedList () {
    return {
      'ETH' : 2.0919878336598 + 0.49830848,
      'EOS' : 23.052502212272,
      'REQ' : 500.00,
      'REP' : 2.2025932637997,
      'SALT': 10.62236917,
      'OMG' : 5.41910301,
      'VIU' : 18.0625296,
      'XVG' : 1198.80,
      'RDN' : 31.96800000,
      'XMR' : 0.17282700,
      'ADA' : 128.0,
      'BCH' : 0.25,
      'BTC' : 0.0025,
      'DASH': 0.45,
      'LTC' : 1.7,
    };
  }

  Future close () async => this.db.close();
  
  Future<List<Map<String, String>>> getWallets () async {
    await this.open();
    List<Map<String, String>> wallets = await db.query('wallet', distinct: true);
    this.close();
    return wallets;
  }

  Future<double> getWalletValues () async {
    List<Map<String, String>> wallets = await this.getWallets();
    List<String> addresses = wallets.map((wallet) => wallet['address']).toList();
    double eth = 0.0;
    addresses.forEach((address) async {
      double balance = (await API.getETHWalletValue(address))['ETH']['balance'];
      eth += balance;
    });
    debugPrint(eth.toString());
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

class WatchlistProvider {
  Database db;
  
  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coinwatch.db");
    this.db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS watchlist (id INTEGER PRIMARY KEY, symbol TEXT UNIQUE);
        CREATE TABLE IF NOT EXISTS wallet (id INTEGER PRIMARY KEY, symbol TEXT, address TEXT UNIQUE);
        INSERT INTO watchlist (symbol) VALUES ('ETH'), ('BCH'), ('DASH'), ('LTC'), ('ADA'), ('EOS');
        INSERT INTO wallet (symbol, address) VALUES ('ETH', '0x3CcD96131c233ceC261f9Be610020939FDC7863E'), ('ETH', '0x42E1F7d6b18b0e51e9B4Ae214BEcCb99eCC24b82');
      ''');
    });
  }

  Future<List<String>> getWatchlist () async {
    await this.open();
    List<Map<String, String>> watchlist = await this.db.query('watchlist', distinct: true);
    return watchlist.map((Map<String, String> item) => item['symbol']).toList();
  }

  Future<bool> inWatchlist (String ticker) async {
    await this.open();
    List<Map<String, String>> exists = await this.db.query('watchlist', where: 'symbol = ?', whereArgs: [ticker], distinct: true);
    await this.db.close();
    return exists.length > 0;
  }

  Future<int> toggleWatchlist (String ticker) async {
    bool watched = await this.inWatchlist(ticker);
    await this.open();
    int res = 0;
    if (watched) {
      debugPrint('removing from watchlist');
      res = await this.db.delete('watchlist', where: 'symbol = ?', whereArgs: [ticker]);
    } else {
      debugPrint('adding to watchlist');
      res = await this.db.insert('watchlist', {'symbol': ticker});
    }
    this.db.close();
    return res;
  }

  Future<List<Card>> getWatchlistCards () async {
    await this.open();
    List<String> watchlist = await this.getWatchlist();
    List<Object> coins = await API.getPrices(filter: watchlist);
    this.db.close();
    return coins.map((Object coin) => currencyCard(
      coin['symbol'],
      coin['name'],
      double.parse(coin['price_usd']),
      double.parse(coin['percent_change_24h']),
    )).toList();
  }

  Future close() async => db.close();
}