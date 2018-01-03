import 'dart:async';
import 'dart:io';

import '../services/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class WalletProvider {
  Database db;
  
  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coinwatch.db");
    this.db = await openDatabase(path, version: 10, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS watchlist (id INTEGER PRIMARY KEY AUTOINCREMENT, symbol TEXT UNIQUE);
        CREATE TABLE IF NOT EXISTS wallet (id INTEGER PRIMARY KEY, symbol TEXT, address TEXT UNIQUE);
      ''');
    });
  }

  Map<String, double> hardcodedList() {
    return {
      'ETH': 0.91188038,
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

  Future<Map<String, double>> getWalletValues() async {
    List<Map<String, String>> wallets = await this.getWallets();
    List<String> addresses = wallets.map((wallet) => wallet['address']).toList();
    Map<String, double> tokens = {};
    addresses.forEach((address) async {
      Map<String, double> values = await API.getETHWalletValue(address);
      values.forEach((String symbol, double value){
        if(tokens.containsKey(symbol)) {
          tokens[symbol] += value;
        } else {
          tokens[symbol] = value;
        }
      });
    });
    debugPrint(tokens.toString());
    return tokens;
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
