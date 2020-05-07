import 'package:Bitalarm/screens/portfolio/add-asset/add-wallet.screen.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class AddWalletButton extends StatelessWidget {
  void _navigateToAddWallet() {
    routePush(AddWalletScreen());
  }

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(color: Colors.white.withOpacity(.5));

    return Container(
        width: 180,
        child: FlatButton(
          onPressed: _navigateToAddWallet,
          child: Text(
            'Manage assets',
            style: style,
          ),
        ));
  }
}
