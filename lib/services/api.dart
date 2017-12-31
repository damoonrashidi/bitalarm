import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    String endpoint = 'https://api.coinmarketcap.com/v1/ticker/?convert=$currency';
    List<Object> list = JSON.decode((await http.get(endpoint)).body);
    if (filter.length == 0) {
      return list;
    } else {
      return list.where((Object coin) => filter.indexOf(coin['symbol']) >= 0).toList();
    }
  }

  static Future<List<Map<String, double>>> getHistorical(String ticker) async {
    String endpoint = 'https://api.kraken.com/0/public/Spread?pair='+ticker+'usd&since='+(new DateTime.now().millisecondsSinceEpoch / 1000 - 86400).toString();
    Object response = JSON.decode((await http.get(endpoint)).body);
    List<List<dynamic>> data = response['result']['X'+ticker.toUpperCase()+'ZUSD'];
    List<Map<String, double>> close = data.map((point) => {
      'time': new DateTime.fromMillisecondsSinceEpoch(point[0] * 1000).toString(), 'value': point[2]
    }).toList();
    return close;
  }

  static Future<Map<String, List<List<double>>>> getOrderbook(String ticker) async {
    String endpoint = 'https://api.cryptowat.ch/markets/bitfinex/'+ticker+'usd/orderbook';
    Object res = JSON.decode((await http.get(endpoint)).body);
    List<List<double>> asks = res['result']['asks'];
    List<List<double>> bids = res['result']['bids'];
    return {
      'asks':asks.sublist(0, 20),
      'bids': bids.sublist(0, 20),
    };
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