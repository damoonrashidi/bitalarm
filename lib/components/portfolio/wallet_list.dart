import 'package:flutter/material.dart';
import '../../services/wallet.service.dart';

class WalletList extends StatelessWidget {

  final List<Object> wallets;
  final _wp = new WalletProvider();
  WalletList({this.wallets});

  String truncateMiddle (String address) {
    if (address.length <= 16) {
      return address;
    } else {
      return address.substring(0,8) + '..' + address.substring(address.length - 8, address.length - 1);
    }
  }

  @override
  Widget build (BuildContext ctx) {
    List<ListTile> list = new List.generate(this.wallets.length, (int i) {
      Object wallet = this.wallets[i];
      return new ListTile(
        dense: true,
        trailing: new PopupMenuButton(
          onSelected: (int value) {
            _wp.removeWallet(wallets[i]['address']);
          },
          itemBuilder: (ctx) => [
            new PopupMenuItem(child: new Text('Stop tracking'), value: i,)
          ],
          icon: const Icon(Icons.more_vert)
        ),
        title: new Text(
          wallet['label'], 
          style: new TextStyle(
            fontSize: 22.0,
            height: 2.0
          ),
        ),
        subtitle: new Text(
          wallet['symbol'].toString().padRight(4) + " " + truncateMiddle(wallet['address']),
          style: new TextStyle(
            color: const Color(0xff333333),
            fontSize: 15.0
          ),
        ),
      );
    });
    return new ListView(children: list);
  }

}