import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/entities/wallet.entity.dart';
import 'package:dio/dio.dart';
import 'apikey.dart';
import 'dart:math';

class WalletService {
  Stream<AssetEntity> getWalletValues(List<WalletEntity> wallets) async* {
    for (var i = 0; i < wallets.length; i++) {
      var wallet = wallets[i];
      switch (wallet.symbol.toLowerCase()) {
        case 'eth':
          var tokens = await _getETH(wallet.address);
          for (var j = 0; j < tokens.length; j++) {
            yield tokens[j];
          }
          break;
        default:
          yield AssetEntity(
              name: wallet.name, amount: 0, symbol: wallet.symbol);
      }
    }
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
