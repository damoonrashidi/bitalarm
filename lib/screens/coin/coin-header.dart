import 'dart:math';

import 'package:Bitalarm/components/screen-headline.dart';
import 'package:Bitalarm/screens/coin/coin-graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CoinHeader extends StatelessWidget {
  final String title;
  final List<double> priceData;

  CoinHeader({this.title, this.priceData = const []});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CoinHeaderDelegate(
          title: title, minExtent: 120, maxExtent: 320, priceData: priceData),
    );
  }
}

class CoinHeaderDelegate implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final String title;
  final List<double> priceData;

  CoinHeaderDelegate({
    this.minExtent,
    @required this.maxExtent,
    this.title,
    this.priceData = const [],
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
      Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            child: CoinGraph(data: priceData),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: IconButton(
              color: Colors.white,
              onPressed: Navigator.of(context).pop,
              icon: Icon(Icons.arrow_back),
            ),
          )
        ],
      ),
    ]);
  }
}
