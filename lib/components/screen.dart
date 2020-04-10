import 'package:Bitalarm/components/bottom-navbar.dart';
import 'package:flutter/material.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget child;
  final String activeNavBar;

  ScreenScaffold({this.child, this.activeNavBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFF),
        body: Stack(children: [
          Image(
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width + 100,
            height: MediaQuery.of(context).size.height,
            image: AssetImage('assets/images/page-background.png'),
          ),
          child
        ]),
        bottomNavigationBar: BitalarmBottomNavBar(active: this.activeNavBar));
  }
}
