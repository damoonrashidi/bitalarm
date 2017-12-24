import 'package:flutter/material.dart';

import './styles.dart';
import './helpers/services.dart';

Drawer sidebarDrawer (dynamic currencies) {
  return new Drawer(
    child: new Container(
      padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text('Sort By'),
          new Text('Filter Currencies'),
        ],
      ),
    ),
  );
}

BottomNavigationBar bottomNav (BuildContext ctx, int navIndex) {
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


Card currencyCard (String ticker, String name, double price, double change, [bool showWatchlistButton = false, List<String> watchlist = const ['ETH','DASH']]) {

  WatchlistProvider wp = new WatchlistProvider();  
  bool trendUp = change > 0;
  Icon _watchlistIcon = new Icon(watchlist.indexOf(ticker) >= 0 ? Icons.favorite : Icons.favorite_border, color: Colors.red,);

  return new Card(
    child: new Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(name, style: headlineTextStyle, overflow: TextOverflow.ellipsis,),
              new Text(price.toString() + " USD", style: headlineTextStyle)
            ],
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: 
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(ticker, style: new TextStyle(color: trendUp ? Colors.grey : Colors.red, fontWeight: FontWeight.w800),),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(change.toString() + "%", style: percentChangeStyle),
                      new Icon(
                        trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                        color:  trendUp ? Colors.blue : Colors.red
                      ),
                    ],
                  ),
                ],
              )
          ),
          !showWatchlistButton ?
          new Row() :
          new Row(
            children: <Widget>[
              new IconButton(icon: _watchlistIcon, onPressed: () async {
                await wp.toggleWatchlist(ticker);
              }),
              new IconButton(icon: new Icon(Icons.details), onPressed: () {
                showDialog(context: ctx, child: new Text('Toggled Favorite'), barrierDismissible: true);
              },)
            ],
          ) 
        ],
      ),
    ),
  );
}