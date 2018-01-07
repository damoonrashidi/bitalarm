import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  
  Future<String> getFiatCurrency() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('fiatCurrency') ?? 'usd';
  }

  void setFiatCurrency(String currency) {
    SharedPreferences.getInstance().then((sp) => sp.setString('fiatCurrency', currency));
  }

  Future<double> getStake() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getDouble('stake') ?? 0.0;
  }

  void setStake(double stake)  {
    SharedPreferences.getInstance().then((sp) => sp.setDouble('stake', stake));
  }

}