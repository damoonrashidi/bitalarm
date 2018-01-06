import 'package:flutter/material.dart';

class AppBotNav extends StatelessWidget {

  final int currentIndex;
  AppBotNav({this.currentIndex});

  @override
  Widget build(BuildContext ctx) {
    return new BottomNavigationBar(
      onTap: (int value) {
        if (value == 0 && currentIndex != 0) {
          Navigator.of(ctx).pushReplacementNamed('/home');
        } else if (value == 1 && currentIndex != 1) {
          Navigator.of(ctx).pushReplacementNamed('/all');
        } else if (currentIndex != 2){
          Navigator.of(ctx).pushReplacementNamed('/portfolio');
        }
      },
      currentIndex: this.currentIndex,
      items: [
        new BottomNavigationBarItem(title: new Text('Watchlist'), icon: const Icon(Icons.favorite)),
        new BottomNavigationBarItem(title: new Text('All'), icon: const Icon(Icons.all_inclusive)),
        new BottomNavigationBarItem(title: new Text('Portfolio'), icon: const Icon(Icons.donut_large)),
      ]
    );
  }
}
