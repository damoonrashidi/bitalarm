import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class CoinService {
  static const _APIKey = 'SECRET_APIKEY';

  Future<List<Coin>> getAllPrices() async {
    String url =
        'https://min-api.cryptocompare.com/data/top/mktcapfull?limit=100&tsym=USD';

    Response response = await Dio()
        .get(url, options: Options(headers: {'Authorization': _APIKey}));

    List<dynamic> data = response.data['Data'];
    List<Coin> coins = data.map((dynamic coin) => Coin.fromJSON(coin)).toList();
    return coins.toList();
  }

  Future<List<Coin>> getPriceForSymbols(List<String> symbols) async {
    var prices = await getAllPrices();

    return prices.where((coin) => symbols.indexOf(coin.symbol) != -1).toList();
  }

  Future<dynamic> getHistoricalCoinData(String symbol) async {
    // String url =
    //     "https://min-api.cryptocompare.com/data/v2/histohour?fsym=$symbol&tsym=USD&limit=10";

    return "Not yet implemented";
  }
}
