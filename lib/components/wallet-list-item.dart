import 'package:Bitalarm/entities/wallet.entity.dart';
import 'package:flutter/material.dart';

class WalletListItem extends StatelessWidget {
  final WalletEntity wallet;
  final Function onPressed;

  WalletListItem({this.wallet, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${wallet.name} - ${wallet.symbol.toUpperCase()}"),
      subtitle: Text(wallet.address),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle),
        onPressed: onPressed,
      ),
    );
  }
}
