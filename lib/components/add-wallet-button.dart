import 'package:Bitalarm/screens/portfolio/add-asset/add-asset.screen.dart';
import 'package:Bitalarm/screens/portfolio/add-asset/add-wallet.screen.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class AddWalletButton extends StatelessWidget {
  void _navigateToManageWallet() {
    routePush(AddWalletScreen());
  }

  void _navigateToManageAssets() {
    routePush(AddAssetScreen());
  }

  _showBottomSheet(BuildContext context) {
    Widget button({String label, String text, Icon icon, Function onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                border:
                    Border.all(width: 1, color: Colors.white.withOpacity(.2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: icon,
                        ),
                        Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )),
                Text(
                  text,
                  style: TextStyle(fontSize: 10),
                )
              ],
            )),
      );
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  button(
                      label: 'Manage wallets',
                      text:
                          'Wallets will find all coins and tokens that belong to them and automatically keep your portfolio up to date.',
                      onTap: _navigateToManageWallet,
                      icon: Icon(Icons.account_balance_wallet,
                          size: 18, color: Colors.white.withOpacity(0.5))),
                  button(
                      label: 'Manage assets',
                      text:
                          'Added assets will be converted to USD and displayed in your portfolio overview.',
                      onTap: _navigateToManageAssets,
                      icon: Icon(Icons.attach_money, size: 18)),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(color: Colors.white.withOpacity(.5));

    return Container(
        width: 180,
        child: FlatButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          child: Text(
            'Manage assets',
            style: style,
          ),
        ));
  }
}
