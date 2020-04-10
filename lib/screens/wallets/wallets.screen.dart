import 'package:Bitalarm/components/bottom-navbar.dart';
import 'package:flutter/material.dart';

class WalletsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('WalletsScreen'),
      ),
      bottomNavigationBar: BitalarmBottomNavBar(active: 'wallets'),
    );
  }
}
