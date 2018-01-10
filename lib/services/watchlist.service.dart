import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WatchlistService {
  Database db;

  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "coinwatch.db");
    this.db = await openDatabase(path, version: 1, onOpen: (Database db) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS watchlist (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          symbol TEXT UNIQUE
        );''');
    });
  }

  Future<List<String>> getWatchlist() async {
    await this.open();
    List<Map<String, String>> watchlist = await this.db.query('watchlist', distinct: true);
    return watchlist.map((Map<String, String> item) => item['symbol']).toList();
  }

  Future<bool> inWatchlist(String ticker) async {
    await this.open();
    List<Map<String, String>> exists = await this.db.query('watchlist', where: 'symbol = ?', whereArgs: [ticker], distinct: true);
    await this.db.close();
    return exists.length > 0;
  }

  Future<int> toggleWatchlist(String ticker) async {
    bool watched = await this.inWatchlist(ticker);
    await this.open();
    int res = 0;
    if (watched) {
      res = await this.db.delete('watchlist', where: 'symbol = ?', whereArgs: [ticker]);
    } else {
      res = await this.db.insert('watchlist', {'symbol': ticker});
    }
    this.db.close();
    return res;
  }

  Future<int> addToWatchlist(String ticker) async {
    await this.open();
    int res = await this.db.insert('watchlist', {'symbol': ticker});
    this.db.close();
    return res;
  }

  Future<int> removeFromWatchlist(String ticker) async {
    if (!(await this.inWatchlist(ticker))) {
      return 0;
    }
    await this.open();
    int res = await this.db.delete('watchlist', where: 'symbol = ?', whereArgs: [ticker]);
    this.db.close();
    return res;
  }

  Future close() async => db.close();
}
