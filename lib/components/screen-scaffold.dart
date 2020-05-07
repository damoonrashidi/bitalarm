import 'dart:math';

import 'package:Bitalarm/components/bottom-navbar.dart';
import 'package:Bitalarm/components/screen-headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenScaffold extends StatelessWidget {
  final List<Widget> children;
  final String activeNavBar;
  final String title;
  final FloatingActionButton fab;
  final Drawer drawer;

  ScreenScaffold(
      {this.children = const [],
      this.fab,
      this.drawer,
      @required this.activeNavBar,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    children.insert(
      0,
      SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate:
            ScreenHeaderDelegate(title: title, minExtent: 0, maxExtent: 100),
      ),
    );

    String lightness =
        Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light';

    return Scaffold(
        drawer: drawer,
        body: Stack(children: [
          Image(
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width + 100,
            height: MediaQuery.of(context).size.height,
            image: AssetImage('assets/images/$lightness-page-background.png'),
          ),
          CustomScrollView(slivers: children),
        ]),
        floatingActionButton: fab,
        bottomNavigationBar: BitalarmBottomNavBar(active: this.activeNavBar));
  }
}

class ScreenHeaderDelegate implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final String title;

  ScreenHeaderDelegate({
    this.minExtent,
    @required this.maxExtent,
    this.title,
  });

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  _getOpacityForOffset(double shrinkOffset) {
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacity = _getOpacityForOffset(shrinkOffset);
    return Stack(fit: StackFit.expand, children: [
      ScreenHeadline(title, opacity: opacity),
    ]);
  }
}
