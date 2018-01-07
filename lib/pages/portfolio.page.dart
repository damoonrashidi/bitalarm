import 'package:flutter/material.dart';
import '../components/bottom_nav.dart';
import '../components/portfolio/wallet_list.dart';
import '../components/portfolio/portfolio_list.dart';
import '../components/portfolio/portfolio_header.dart';
import '../components/pill_button.dart';

import '../services/wallet.service.dart';
import '../services/settings.service.dart';

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
  WalletProvider _wp = new WalletProvider();
  SettingsService _ss = new SettingsService();

  initStateAsync() async {
    _wallets = await _wp.getWallets();
    _coins = await _wp.getWalletValues();
    _stake = await _ss.getStake();
    setState((){});
    _coins = await _wp.coinsToPrice(coins: _coins, currency: 'sek');
    _total = _coins.map((coin) => coin['value']).reduce((double a, double b) => a + b);
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      drawer: new Drawer(
        child: new Column(children: [
          new Expanded(child: new WalletList(wallets: _wallets)),
          new Container(
            height: 50.0,
            width: 200.0,
            margin: const EdgeInsets.only(bottom: 50.0, top: 50.0),
            child: new PillButton(
              child: new Text('Add a wallet'),
              onPressed: () => Navigator.of(ctx).pushReplacementNamed('/wallets')
            )
          )
        ])
      ),
      body: new Column(
        children: [
          new Stack(children: <Widget>[
            new Container(
              height: 230.0,
              child: new PortfolioHeader(total: _total, stake: _stake),
            ),
            new Container(
              height: 40.0,
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.settings), 
                    onPressed: () => Navigator.of(ctx).pushNamed('/settings'), 
                  )
                ],
              ),
            ),
          ]),
          new Expanded(
            child: new ListView(children: [new PortfolioList(coins: _coins)])
          ),
        ],
      ),
      bottomNavigationBar: new AppBotNav(currentIndex: 2),
    );
  }
}
