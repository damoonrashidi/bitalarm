import 'package:flutter/material.dart';

Map<String, double> convertPortfolioToSEK(Map<String, double> portfolio, List<Object> prices) {
  Map<String, double> sek = {};
  portfolio.forEach((String symbol, double amount) {
    Object coin = prices.firstWhere((coin) => coin['symbol'] == symbol, orElse: () => {'price_sek' : "0.0"});
    debugPrint(coin.toString());
    sek[symbol] = amount * double.parse(coin['price_sek']);
  });
  return sek;
}
