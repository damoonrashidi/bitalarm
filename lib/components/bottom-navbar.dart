import 'package:Bitalarm/screens/favorites/favorites.screen.dart';
import 'package:Bitalarm/screens/toplist/toplist.screen.dart';
import 'package:Bitalarm/screens/wallets/wallets.screen.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

class BitalarmBottomNavBar extends StatelessWidget {
  final String active;

  BitalarmBottomNavBar({this.active});

  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text('Favorites'),
              activeIcon: Icon(Icons.favorite)),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('All'),
              activeIcon: Icon(Icons.filter_list)),
          BottomNavigationBarItem(
              icon: Icon(Icons.work),
              title: Text('Portfolio'),
              activeIcon: Icon(Icons.monetization_on)),
        ],
        currentIndex: ['favorites', 'toplist', 'wallets']
            .indexWhere((element) => element == active),
        onTap: (int i) {
          Widget screen =
              [FavoritesScreen(), TopListScreen(), WalletsScreen()][i];
          routePush(screen, RouterType.material);
        });
  }
}
