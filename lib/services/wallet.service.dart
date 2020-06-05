import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/entities/wallet.entity.dart';
import 'package:dio/dio.dart';
import 'apikey.dart';
import 'dart:math';

class WalletService {
  Stream<AssetEntity> getWalletValues(List<WalletEntity> wallets) async* {
    for (var i = 0; i < wallets.length; i++) {
      var wallet = wallets[i];
      switch (wallet.symbol.toUpperCase()) {
        case 'ETH':
          var tokens = await _getETH(wallet.address);
          for (var j = 0; j < tokens.length; j++) {
            yield tokens[j];
          }
          break;
        case 'LTC':
          var ltc = await _getLTC(wallet.address);
          yield ltc;
          break;
        case 'BTC':
          yield await _getBTC(wallet.address);
          break;
        default:
          yield AssetEntity(
              name: wallet.name, amount: 0, symbol: wallet.symbol);
      }
    }
  }

  Future<AssetEntity> _getLTC(String address) async {
    String url =
        "https://sochain.com/api/v2/get_address_balance/LTC/$address/500";
    Response response = await Dio().get(url);
    var balance = response.data['data']['confirmed_balance'];
    return AssetEntity(
        name: 'Litecoin', symbol: 'LTC', amount: double.parse(balance));
  }

  Future<AssetEntity> _getBTC(String address) async {
    String url =
        "https://sochain.com/api/v2/get_address_balance/BTC/$address/500";
    Response response = await Dio().get(url);
    var balance = response.data['data']['confirmed_balance'];
    return AssetEntity(
        name: 'Bitcoin', symbol: 'BTC', amount: double.parse(balance));
  }

  Future<List<AssetEntity>> _getETH(String address) async {
    List<AssetEntity> tokens = [];
    String url =
        "https://api.ethplorer.io/getAddressInfo/$address?apiKey=$ETHPLORER_APIKEY";

    Response response = await Dio().get(url);

    var data = response.data;

    var eth = AssetEntity(
        name: 'Ethereum', symbol: 'ETH', amount: data['ETH']['balance']);

    tokens.add(eth);

    data['tokens'].forEach((token) {
      double amount = 0.0;

      var decimals = token['tokenInfo']['decimals'];
      var balance = token['balance'] / 1.0;

      if (decimals == '0' || decimals == 0) {
        amount = balance;
      } else if (decimals is String) {
        amount = balance / (pow(10, double.parse(decimals)));
      } else {
        amount = balance / pow(10, decimals);
      }

      tokens.add(AssetEntity(
        name: token['tokenInfo']['name'],
        amount: amount,
        symbol: token['tokenInfo']['symbol'],
      ));
    });

    return tokens;
  }
}
