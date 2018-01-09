import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import '../services/settings.service.dart';
import '../services/fiat.service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  

  List<Map<String, String>> fiatCurrencies = getFiatCurrencies();
  SettingsService _settings = new SettingsService();
  TextEditingController _stakeCtrl = new TextEditingController();
  String _selectedFiat = 'USD';
  double _stake = 0.0;
  bool _darkTheme = false;

  initStateAsync() async {
    _selectedFiat = await _settings.getFiatCurrency();
    _stake = await _settings.getStake() ?? 0.0;
    _darkTheme = await _settings.getTheme();
    _stakeCtrl.text = _stake.toString();
  }

  @override
  initState() {
    this.initStateAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {

    List<DropdownMenuItem<String>> fiatCurrencyItems = new List.generate(fiatCurrencies.length, (int i) {
      return new DropdownMenuItem(
        value: fiatCurrencies[i]['symbol'],
        child: new Text(fiatCurrencies[i]['name']),
      );
    });

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(ctx)),
        title: new Text('Settings')
      ),
      body: new Form(child: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Column(children: [
          new DropdownButton(
            value: _selectedFiat,
            hint: new Text('Select a currency'),
            isDense: true,
            items: fiatCurrencyItems,
            onChanged: (String symbol) {
              _settings.setFiatCurrency(symbol);
            }, 
          ),
          new TextField(
            controller: _stakeCtrl,
            onChanged: (String stake) => _settings.setStake(double.parse(stake)),
            decoration: new InputDecoration(
              labelText: 'Stake',
            ),
          ),
          new Row(children: <Widget>[
            new Text('Dark theme'),
            new Switch(
              value: _darkTheme, 
              onChanged: (bool toggled) {
                _darkTheme = toggled;
                _settings.setTheme(dark: toggled);
              },
            ),
          ],)
        ])
      ))
    );
  }
}