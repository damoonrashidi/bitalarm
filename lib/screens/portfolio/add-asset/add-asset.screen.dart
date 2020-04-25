import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAssetScreen extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  String _symbol = '';
  String _name = '';
  double _amount = 0.0;

  _addAsset(BuildContext context) {
    _formKey.currentState.save();

    var asset = AssetEntity(name: _name, symbol: _symbol, amount: _amount);

    var store = Provider.of<WalletsModel>(context, listen: false);
    store.addAsset(asset);
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
                        _symbol = symbol.toLowerCase();
                      },
                      decoration:
                          InputDecoration(labelText: "Symbol", hintText: 'BTC'),
                    ),
                    TextFormField(
                      onSaved: (String name) {
                        _name = name;
                      },
                      decoration: InputDecoration(
                          labelText: "Name", hintText: 'Bitcoin'),
                    ),
                    TextFormField(
                      onSaved: (String amount) {
                        _amount = double.parse(amount);
                      },
                      decoration: InputDecoration(
                          labelText: "Amount", hintText: '0.07'),
                    ),
                    RaisedButton(
                      child: Text('Add asset'),
                      onPressed: () {
                        _addAsset(context);
                      },
                    )
                  ],
                ))));
  }
}
