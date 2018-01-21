import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/wallet.service.dart';

class WalletList extends StatelessWidget {

  final List<Object> wallets;
  final _ws = new WalletService();
  WalletList({this.wallets});

  String truncateMiddle (String address) {
    if (address.length <= 16) {
      return address;
    } else {
      return address.substring(0,6) + '..' + address.substring(address.length - 8, address.length - 1);
    }
  }

  @override
  Widget build (BuildContext ctx) {
    List<Container> list = new List.generate(this.wallets.length, (int i) {
      Object wallet = this.wallets[i];
      return new Container(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: new BoxDecoration(
          border: new Border(bottom: const BorderSide(width: 0.5, color: const Color(0xffe7e7e7)))
        ),
        child: new ListTile(
          dense: true,
          trailing: new PopupMenuButton(
            onSelected: (Object event) async {
              if (event['action'] == 'remove') {
                await _ws.removeWallet(event['data']);
                Scaffold.of(ctx).showSnackBar(new SnackBar(content: new Text('Stopped tracking ' + truncateMiddle(event['data']))));
              } else if (event['action'] == 'copy') {
                Clipboard.setData(new ClipboardData(text: event['data']));
                Scaffold.of(ctx).showSnackBar(new SnackBar(content: new Text('Copied to clipboard!')));
              }
              Navigator.of(ctx).pop();
            },
            itemBuilder: (ctx) => [
              new PopupMenuItem(child: new Text('Stop tracking'), value: {'action':'remove', 'data': wallets[i]['address']}),
              new PopupMenuItem(child: new Text('Copy to clipboard'), value: {'action':'copy', 'data': wallets[i]['address']}),
            ],
            icon: const Icon(Icons.more_vert)
          ),
          title: new Text(
            wallet['label'], 
            style: new TextStyle(
              fontSize: 18.0,
              height: 2.0
            ),
          ),
          subtitle: new Text(
            wallet['symbol'].toString().padRight(4) + " " + truncateMiddle(wallet['address']),
            style: new TextStyle(
              color: const Color(0xff333333),
              fontSize: 14.0,
              fontWeight: FontWeight.w100,
            ),
          ),
        )
      );
    });
    return new ListView(children: list);
  }

}