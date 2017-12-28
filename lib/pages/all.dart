import 'package:flutter/material.dart';
import '../components.dart';
import '../helpers/services.dart';

class AllCurrenciesPage extends StatefulWidget {
  AllCurrenciesPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AllCurrenciesState createState() => new _AllCurrenciesState();
}

enum SortOrder { marketCap, trending, losing }

class _AllCurrenciesState extends State<AllCurrenciesPage> with SingleTickerProviderStateMixin {
  Map<String, Object> _prices = {};
  List<Dismissible> _list = [];
  List<String> _watchlist = [];
  WatchlistProvider watchProvider = new WatchlistProvider();
  SortOrder _sortOrder = SortOrder.marketCap;
  TextEditingController _filterController;

  _refreshValue() async {
    _list = [];
    _prices = {};
    _watchlist = await watchProvider.getWatchlist();
    List<Object> data = await API.getPrices();
    if (_sortOrder == SortOrder.trending) {
      data.sort((Object a, Object b) => double.parse(a['percent_change_24h']) > double.parse(b['percent_change_24h']) ? -1 : 1);
    } else if (_sortOrder == SortOrder.losing) {
      data.sort((Object a, Object b) => double.parse(a['percent_change_24h']) > double.parse(b['percent_change_24h']) ? 1 : -1);
    }
    for (var currency in data) {
      if (_filterController.text != '' && 
          _filterController.text.indexOf(currency['symbol'].toLowerCase()) >= 0 ||
          _filterController.text.indexOf(currency['name'].toLowerCase()) >= 0
      ) {
        _prices[currency['symbol']] = currency;
      } else if (_filterController.text == '') {
        _prices[currency['symbol']] = currency;
      }
    }
    _prices.forEach((String ticker, Object data) {
      _list.add(currencyCard(
        data['symbol'],
        data['name'],
        double.parse(data['price_usd']),
        double.parse(data['percent_change_24h']),
        true,
        _watchlist,
      ));
    });
    setState((){});
  }

  void setSortOrder({SortOrder order = SortOrder.marketCap}) {
    _sortOrder = order;
    _refreshValue();
  }


  @override
  void initState() {
    _filterController = new TextEditingController(text: '');
    super.initState();
    _refreshValue();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      bottomNavigationBar: bottomNav(ctx, 1),
      drawer: new Drawer(
        child: new Container(
          margin: const EdgeInsets.only(top: 48.0, bottom: 20.0),
          child: new Column(
            children: [
              new Text('Sort list by', style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
              new ListTile(
                leading: new Icon(Icons.public),
                title: new Text('Market cap'),
                onTap: () => this.setSortOrder(order: SortOrder.marketCap)
              ),
              new ListTile(
                leading: new Icon(Icons.whatshot),
                title: new Text('Hot'),
                onTap: () => this.setSortOrder(order: SortOrder.trending)
              ),
              new ListTile(
                leading: new Icon(Icons.trending_down),
                title: new Text('Losing'),
                onTap: () => this.setSortOrder(order: SortOrder.losing)
              ),
            ],
          ),
        )
      ),
      body: new Container(
        child: new Column(children: <Widget>[
          new Container(
            height: 100.0,
            padding: new EdgeInsets.only(top: 24.0, bottom: 10.0),
            margin: new EdgeInsets.all(0.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [const Color(0xff2628FF), const Color(0xff1819AA)],
              )
            ),
            child: new TextField(
              controller: _filterController,
              autocorrect: false,
              autofocus: false,
              style: const TextStyle(color: const Color(0x99ffffff)),
              decoration: new InputDecoration(
                labelText: 'Symbol or name',
                hintText: 'ETH',
                icon: const Icon(Icons.filter_list, color: const Color(0x99ffffff),),
                hintStyle: const TextStyle(color: const Color(0x99ffffff))
              ),
              onChanged: (String value) {
                _filterController.text = value.toLowerCase();
                _refreshValue();
              },
            ),
          ),
          new Expanded(
            child: new ListView(
              children: _list,
            ),
          ),
        ],)
      ),
    );
  }
}
