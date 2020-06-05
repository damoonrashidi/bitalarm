import 'package:Bitalarm/components/wallet-list-item.dart';
import 'package:Bitalarm/entities/wallet.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AddWalletScreen extends StatefulWidget {
  @override
  _AddWalletScreenState createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _addressController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  String _symbol = '';
  String _name = '';
  String _address = '';

  _addWallet(BuildContext context) {
    _formKey.currentState.save();

    if ([_name, _symbol, _address].contains('')) {
      return;
    }

    var wallet = WalletEntity(name: _name, symbol: _symbol, address: _address);

    var store = Provider.of<WalletsModel>(context, listen: false);
    store.addWallet(wallet);
  }

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<WalletsModel>(context);

    var walletWidgets = store.wallets
        .map((wallet) => WalletListItem(
              wallet: wallet,
              onPressed: () {
                store.removeWallet(wallet);
              },
            ))
        .toList();

    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  onSaved: (String name) {
                    _name = name;
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      controller: _addressController,
                      onSaved: (String address) {
                        _address = address;
                      },
                      decoration: InputDecoration(labelText: 'Address'),
                    )),
                    IconButton(
                      onPressed: () async {
                        String code = await scanner.scan();
                        _addressController.text = code;
                      },
                      icon: Icon(Icons.camera_alt),
                    )
                  ],
                ),
                TextFormField(
                  onSaved: (String symbol) {
                    _symbol = symbol;
                  },
                  decoration: InputDecoration(labelText: 'Symbol'),
                ),
                RaisedButton.icon(
                    onPressed: () {
                      _addWallet(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add wallet')),
                Expanded(
                  child: ListView(
                    children: walletWidgets,
                  ),
                )
              ],
            ),
          )),
    ));
  }
}
