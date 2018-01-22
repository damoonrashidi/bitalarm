import 'package:flutter/material.dart';

enum SortOrder {
  marketCap,
  trending,
  losing,
}

class AllDrawer extends StatelessWidget {

  final Function callback;

  AllDrawer({this.callback});

  @override
  Widget build(BuildContext ctx) {
    return new Drawer(
      child: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 18.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Expanded(child: new Column(
              children: [
                new ListTile(
                  leading: new Icon(Icons.public),
                  title: new Text('Market cap'),
                  onTap: () {
                    Function.apply(callback, [SortOrder.marketCap]);
                    Navigator.of(ctx).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.whatshot),
                  title: new Text('Hot'),
                  onTap: () {
                    Function.apply(callback, [SortOrder.trending]);
                    Navigator.of(ctx).pop();
                  }),
                new ListTile(
                  leading: new Icon(Icons.trending_down),
                  title: new Text('Losing'),
                  onTap: () {
                    Function.apply(callback, [SortOrder.losing]);
                    Navigator.of(ctx).pop();
                  }),
                ]
              )
            ),
            new Container(
              height: 200.0,
              child: new Column(children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.attach_money),
                  title: new Text('Add an asset'),
                  onTap: () => Navigator.of(ctx).pushNamed('/assets')
                ),
                new ListTile(
                  leading: new Icon(Icons.account_balance_wallet),
                  title: new Text('Add a wallet'),
                  onTap: () => Navigator.of(ctx).pushNamed('/wallets')
                ),
                new ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text('Settings'),
                  onTap: () => Navigator.of(ctx).pushNamed('/settings')
                )
              ],)
            )
          ], 
        ),
      )
    );
  }
}
