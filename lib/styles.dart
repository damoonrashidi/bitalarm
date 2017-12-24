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

Color getTickerColor(String ticker) {
  Map<String, Color> colors = {
    'ETH' : Colors.orangeAccent[500],
    'EOS' : Colors.grey[200],
    'REQ' : Colors.blue[200],
    'REP' : Colors.blueGrey[200],
    'SALT': Colors.brown[200],
    'OMG' : Colors.cyan[200],
    'VIU' : Colors.deepOrange[200],
    'XVG' : Colors.deepPurple[200],
    'RDN' : Colors.green[200],
    'XMR' : Colors.indigo[200],
    'ADA' : Colors.lightBlue[200],
    'BCH' : Colors.lime[200],
    'BTC' : Colors.orange[200],
    'DASH': Colors.purple[200],
    'LTC' : Colors.red[200],
  };
  if (!colors.containsKey(ticker)) {
    return Colors.white;
  } else {
    return colors[ticker];
  }
}