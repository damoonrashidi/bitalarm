import 'package:flutter/material.dart';

enum SortOrder {
  marketCap,
  trending,
  losing,
}

Drawer allDrawer(BuildContext ctx, Function callback) {
  return new Drawer(
    child: new Container(
      margin: const EdgeInsets.only(top: 48.0, bottom: 20.0),
      child: new Column(
        children: [
          new Text(
            'Sort list by',
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
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
        ],
      ),
    )
  );
}
