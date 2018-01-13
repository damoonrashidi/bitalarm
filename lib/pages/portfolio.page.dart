import 'package:flutter/material.dart';
import '../components/bottom_nav.dart';
import '../components/portfolio/wallet_list.dart';
import '../components/portfolio/portfolio_list.dart';
import '../components/portfolio/portfolio_header.dart';
import '../components/portfolio/portfolio_chart.dart';

import '../services/wallet.service.dart';
import '../services/settings.service.dart';
import '../services/api.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PortfolioPageState createState() => new _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  List<Object> _wallets = [];
  List<Object> _coins = [];
  double _total = 0.0;
  double _stake = 0.0;
  String _fiat = 'USD';
  WalletProvider _wp = new WalletProvider();
  SettingsService _ss = new SettingsService();

  initStateAsync() async {
    _fiat = await _ss.getFiatCurrency();
    _stake = await _ss.getStake();
    List<Object> prices = await API.getPrices(currency: _fiat);
    _wallets = await _wp.getWallets();
    setState((){});
    setState((){});
    await for (Object coin in _wp.getWalletValues()) {
      accumelateCoin(coin: coin, prices: prices);
      _total = _coins.map((coin) => coin['value']).reduce((double a, double b) => a + b);
      setState((){});
    }
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  /*
   * Add a coin to the coin list as a side effect..
   */
  void accumelateCoin({Object coin, List<Object> prices}) {
    dynamic price = prices.firstWhere(
      (needle) => needle['symbol'] == coin['symbol'],
      orElse: () => {'price_${_fiat.toLowerCase()}': 0.0}
    )['price_${_fiat.toLowerCase()}'];

    if (price is String) {
      price = double.parse(price);
    }
    
    bool found = false;
    for (int i = 0; i < _coins.length; i++) {
      if (_coins[i]['symbol'] == coin['symbol']) {
        _coins[i]['value'] = _coins[i]['value'] + _coins[i]['amount'] * price;
        found = true;
      }
    }
    if (!found) {
      _coins.add({
        'symbol': coin['symbol'],
        'amount': coin['amount'],
        'value':  coin['amount'] * price,
      });
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add a wallet',
        child: new Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          Navigator.pushNamed(ctx, '/wallets');
        },
      ),
      drawer: new Drawer(
        child: new Column(children: [
          new Expanded(child: new WalletList(wallets: _wallets)),
          new Container(
            height: 150.0,
            child: new Column(children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.add),
                title: new Text('Add a wallet'),
                onTap: () => Navigator.of(ctx).pushNamed('/wallets')
              ),
              new ListTile(
                leading: new Icon(Icons.settings),
                title: new Text('Settings'),
                onTap: () => Navigator.of(ctx).pushNamed('/settings')
              )
            ],)
          )
        ])
      ),
      body: new Column(
        children: [
          new Stack(children: <Widget>[
            new Container(
              height: 230.0,
              child: new PortfolioHeader(total: _total, stake: _stake, fiat: _fiat),
            ),
            new RowWithMenu(),
          ]),
          new Expanded(
            child: new ListView(children: [
              _coins.length == 0 //&& _total == 0
                ? new Center(child: new CircularProgressIndicator(backgroundColor: Theme.of(ctx).primaryColor))
                : new PortfolioChart(data: _coins),
              _coins.length == 0
                ? new Center(child: new Text('Add a wallet or asset to start your portfolio'))
                : new PortfolioList(coins: _coins, fiat: _fiat,)
            ])
          ),
        ],
      ),
      bottomNavigationBar: new AppBotNav(currentIndex: 2),
    );
  }
}


class RowWithMenu extends StatelessWidget {
  @override
  Widget build (BuildContext ctx) {
    return new Container(
      margin: new EdgeInsets.only(left: 15.0, top: 32.0),
      child: new IconButton(
        icon: new Icon(Icons.menu, size: 32.0),
        color: Colors.white,
        onPressed: () {
          Scaffold.of(ctx).openDrawer();
        },
      ) 
    );
  }
}