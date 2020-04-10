import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/services/apikey.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:dio_http_cache/dio_http_cache.dart';

class CoinService {
  /*
   * The APIKEY variable is importaed from './apikey.dart', purposefully omitted from the repo
   * to avoid leaking it on Github. I'll create a proxy server for it later, but for now you can
   * sign up for your own dev key @ coinmarketcap
   */
  static const _APIKey = APIKEY;
  Dio dio = Dio();

  CoinService() {
    dio.interceptors.add(DioCacheManager(
            CacheConfig(baseUrl: "https://pro-api.coinmarketcap.com"))
        .interceptor);
  }

  Future<List<Coin>> getAllPrices() async {
    String url =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=100';

    var options = buildCacheOptions(Duration(minutes: 15));
    options.headers['X-CMC_PRO_API_KEY'] = _APIKey;

    Response response = await Dio().get(url, options: options);

    List<dynamic> data = response.data['data'];
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
