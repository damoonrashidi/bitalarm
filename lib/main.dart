import 'package:flutter/material.dart';
import './pages/all.page.dart';
import './pages/watchlist.page.dart';
import './pages/portfolio.page.dart';
import './pages/details.page.dart';
import './pages/wallet.page.dart';
import './styles.dart';

void main() {
  runApp(new BitAlarm());
}

Route<Null> _getRoute(RouteSettings settings) {
  final List<String> path = settings.name.split('/');
  if (path[0] != '') {
    return null;
  } else if (path.indexOf('details') >= 0) {
    String ticker = path[path.length - 1];
    return new MaterialPageRoute<Null>(
      builder: (BuildContext context) => new DetailsPage(ticker: ticker),
    );
  } else {
    return new MaterialPageRoute<Null>(
      builder: (BuildContext context) => new WatchlistPage(),
    );
  }
}

class BitAlarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BitAlarm',
      theme: customTheme,
      home: new WatchlistPage(title: 'BitAlarm'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext ctx) => new WatchlistPage(),
        '/all': (BuildContext ctx) => new AllCurrenciesPage(),
        '/portfolio': (BuildContext ctx) => new PortfolioPage(),
        '/details': (BuildContext ctx) => new DetailsPage(),
        '/wallets': (BuildContext ctx) => new WalletPage(),
      },
      onGenerateRoute: _getRoute,
    );
  }
}
