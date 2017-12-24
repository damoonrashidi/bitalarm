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

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 15);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height);
    var secondPoint = new Offset(size.width, size.height - 15);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

ClipPath headerArc (double _total, double _stake) {
  return new ClipPath(
    clipper: new ArcClipper(),
    child: new Container(
      padding: const EdgeInsets.only(top: 40.0, bottom: 32.0),
      width: 900.0,
      height: 220.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [const Color(0xff2628FF), const Color(0xff1819AA)],
          stops: [0.0, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: new Border(bottom: new BorderSide(width: 0.5, color: Colors.grey),)
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              new Text(_total.toStringAsFixed(0), style: const TextStyle(fontSize: 45.0, fontWeight: FontWeight.w300, color: Colors.white,),),
              new Text('SEK', style: const TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w100),)
            ]
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('STAKE', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 10.0),),
                  new Text(_stake.toStringAsFixed(0) + " SEK", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.0)),
                ],
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text('Profit', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 10.0),),
                  new Text((_total - _stake).toStringAsFixed(0) + " SEK", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15.0)),
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}