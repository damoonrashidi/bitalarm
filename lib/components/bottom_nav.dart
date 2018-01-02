import 'package:flutter/material.dart';

BottomNavigationBar bottomNav(BuildContext ctx, int navIndex) {
  return new BottomNavigationBar(
    onTap: (int value) {
      if (value == 0 && navIndex != 0) {
        Navigator.pushReplacementNamed(ctx, '/home');
      } else if (value == 1 && navIndex != 1) {
        Navigator.pushReplacementNamed(ctx, '/all');
      } else if (value == 2 && navIndex != 2) {
        Navigator.pushReplacementNamed(ctx, '/portfolio');
      }
    },
    currentIndex: navIndex,
    items: [
      new BottomNavigationBarItem(
        title: new Text('Watchlist'),
        icon: new Icon(Icons.favorite),
      ),
      new BottomNavigationBarItem(
        title: new Text('All'),
        icon: new Icon(Icons.all_inclusive),
      ),
      new BottomNavigationBarItem(
        title: new Text('Portfolio'),
        icon: new Icon(Icons.donut_large),
      ),
    ],
  );
}
