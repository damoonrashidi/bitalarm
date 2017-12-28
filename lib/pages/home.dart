import 'package:flutter/material.dart';

import '../components.dart';
import '../helpers/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic _prices = [];
  List<Card> _list = [];
  WatchlistProvider _wp = new WatchlistProvider();

  _getList () async {
    _list = await this._wp.getWatchlistCards();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      bottomNavigationBar: bottomNav(ctx, 0),
      body: new Container(
        padding: new EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
        child: new ListView(
          children: _list,
        ),
      ),
    );
  }
}
