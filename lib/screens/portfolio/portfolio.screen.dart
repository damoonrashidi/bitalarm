import 'package:Bitalarm/components/screen-headline.dart';
import 'package:Bitalarm/components/screen.dart';
import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: "portfolio",
        activeNavBar: "portfolio",
        children: [
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [])
          ])),
        ]);
  }
}
