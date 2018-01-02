import 'package:flutter/material.dart';
import './pages/all.dart';
import './pages/home.dart';
import './pages/portfolio.dart';
import './pages/details.dart';
import './styles.dart';

final router = new Router();

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
      builder: (BuildContext context) => new MyHomePage(),
    );
  }
}

class BitAlarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BitAlarm',
      theme: customTheme,
      home: new MyHomePage(title: 'BitAlarm'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext ctx) => new MyHomePage(),
        '/all': (BuildContext ctx) => new AllCurrenciesPage(),
        '/portfolio': (BuildContext ctx) => new PortfolioPage(),
        '/details': (BuildContext ctx) => new DetailsPage(),
      },
      onGenerateRoute: _getRoute,
    );
  }
}
