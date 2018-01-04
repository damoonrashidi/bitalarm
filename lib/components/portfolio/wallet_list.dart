import 'package:flutter/material.dart';

class WalletList extends StatelessWidget {

  final List<String> addresses;
  WalletList({this.addresses});

  @override
  Widget build (BuildContext ctx) {
    List<ListTile> list = new List.generate(this.addresses.length, (int i) {
      return new ListTile(
        leading: new Icon(Icons.access_alarm),
        title: const Text('ETH'),
        subtitle: new Text(this.addresses[i]),
      );
    });
    return new Column(
      children: list
    );
  }

}