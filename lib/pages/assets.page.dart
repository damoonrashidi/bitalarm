import 'package:flutter/material.dart';
import '../services/wallet.service.dart';
import '../services/fiat.service.dart';
import '../components/pill_button.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => new _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  

  List<Map<String, String>> fiatCurrencies = getFiatCurrencies();
  TextEditingController _symbol = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  WalletService _ws = new WalletService();
  List<Object> _assets = [];

  addAsset () async {
    double amount = double.parse(_amount.text);
    _ws.addAsset(_symbol.text, amount);
  }

  initAsyncState() async {
    _assets = await _ws.getAssets();
  }

  @override
  initState() {
    initAsyncState();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    List<ListTile> _assetList = new List.generate(_assets.length, (int i) {
      return new ListTile(
        title: new Text(_assets[i]['symbol'].toString()),
        subtitle: new Text(_assets[i]['amount'].toString()),
        onTap: () {
          setState((){
            _assets.removeWhere((asset) => asset['id'] == _assets[i]['id']);
            _ws.removeAsset(_assets[i]['id']);
          });
        },
      );
    });
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(ctx)),
        title: new Text('Assets')
      ),
      body: new Form(child: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Column(children: [
          new TextFormField(
            controller: _symbol,
            decoration: new InputDecoration(
              labelText: 'Symbol'
            ),
          ),
          new TextFormField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Amount'
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 18.0),
            child: new PillButton(
              onPressed: addAsset,
              child: new Text('Add asset'),
              minWidth: 300.0,
              color: Colors.grey[300],
            )
          ),
          new Expanded(
            child: new ListView(children: _assetList),
          ),
        ])
      ))
    );
  }
}