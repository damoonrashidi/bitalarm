import 'package:flutter/material.dart';

class WalletList extends StatelessWidget {

  final List<Object> wallets;
  WalletList({this.wallets}) {
    debugPrint(this.wallets.toString());
  }

  String truncateMiddle (String address) {
    return address.substring(0,8) + '..' + address.substring(address.length - 8, address.length - 1);
  }

  @override
  Widget build (BuildContext ctx) {
    List<ListTile> list = new List.generate(this.wallets.length, (int i) {
      Object wallet = this.wallets[i];
      return new ListTile(
        leading: new IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            debugPrint(wallets.toString());
          },
        ),
        title: new Text(
          wallet['label'], 
          style: new TextStyle(
            fontSize: 22.0,
            fontFamily: 'Roboto Mono',
            height: 2.0
          ),
        ),
        subtitle: new Text(
          wallet['symbol'].toString().padRight(4) + " " + truncateMiddle(wallet['address']),
          style: new TextStyle(
            fontFamily: 'Roboto Mono',
            fontWeight: FontWeight.bold,
            color: const Color(0xff333333),
            fontSize: 15.0
          ),
        ),
      );
    });
    return new ListView(
      children: list
    );
  }

}