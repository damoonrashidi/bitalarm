import 'package:Bitalarm/screens/portfolio/add-asset/add-wallet.screen.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class AddWalletButton extends StatelessWidget {
  void _navigateToAddWallet() {
    routePush(AddWalletScreen());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _navigateToAddWallet,
        child: Container(
          width: 120,
          height: 60,
          child: Row(children: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ADD',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'WALLET',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ]),
        ));
  }
}
