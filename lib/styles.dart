import 'package:flutter/material.dart';

const headlineTextStyle = const TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

const percentChangeStyle = const TextStyle(
  fontSize: 14.0,
);

const tickerNameStyle = const TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
);

const headerColumnLabel = const TextStyle(
    color: Colors.white, fontWeight: FontWeight.w200, fontSize: 10.0);

const primaryGradient = const LinearGradient(
  colors: const [const Color(0xff2628FF), const Color(0xff1819AA)],
  stops: const [0.0, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

Color getSymbolColor(String symbol) {
  Map<String, Color> colors = {
    'ETH': Colors.orange,
    'EOS': Colors.grey[200],
    'REQ': Colors.blue[200],
    'REP': Colors.blueGrey[200],
    'SALT': Colors.brown[200],
    'OMG': Colors.cyan[200],
    'VIU': Colors.deepOrange[200],
    'XVG': Colors.deepPurple[200],
    'RDN': Colors.green[200],
    'XMR': Colors.indigo[200],
    'ADA': Colors.lightBlue[200],
    'BCH': Colors.lime[200],
    'BTC': Colors.orange[200],
    'DASH': Colors.purple[200],
    'LTC': Colors.red[200],
  };
  if (!colors.containsKey(symbol)) {
    return Colors.black;
  } else {
    return colors[symbol];
  }
}

ThemeData customTheme = new ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xff1819AA),
    primaryColorBrightness: Brightness.dark,
    accentColor: Colors.deepPurpleAccent,
    accentColorBrightness: Brightness.light);
