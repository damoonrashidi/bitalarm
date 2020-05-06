import 'package:Bitalarm/entities/wallet.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AddWalletScreen extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  String _symbol = '';
  String _name = '';
  String _address = '';

  _addAsset(BuildContext context) {
    _formKey.currentState.save();

    var wallet = WalletEntity(name: _name, symbol: _symbol, address: _address);

    var store = Provider.of<WalletsModel>(context, listen: false);
    store.addWallet(wallet);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.all(32),
            height: 400,
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (String symbol) {
                        _symbol = symbol.toUpperCase().trim();
                      },
                      decoration:
                          InputDecoration(labelText: "Symbol", hintText: 'BTC'),
                    ),
                    TextFormField(
                      onSaved: (String name) {
                        _name = name.trim();
                      },
                      decoration: InputDecoration(
                          labelText: "Name", hintText: 'Bitcoin'),
                    ),
                    TextFormField(
                      onSaved: (String address) {
                        _address = address;
                      },
                      decoration: InputDecoration(
                          labelText: "Address",
                          hintText: '44acx3ax44af9f4dfaded...'),
                    ),
                    RaisedButton(
                      child: Text('Add asset'),
                      onPressed: () {
                        _addAsset(context);
                      },
                    ),
                    RaisedButton(
                      child: Text('Scan a QR code'),
                      onPressed: () async {
                        String code = await scanner.scan();
                        print(code);
                        _address = code;
                      },
                    )
                  ],
                ))));
  }
}
