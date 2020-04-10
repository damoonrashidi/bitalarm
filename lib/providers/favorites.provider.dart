import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/entities/favorite.entity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritesModel extends ChangeNotifier {
  var box = Hive.box<FavoriteEntity>('favorites');
  List<FavoriteEntity> list = [];

  FavoritesModel() {
    list = box.values.toList();
    notifyListeners();
  }

  addFavorite(FavoriteEntity favorite) {
    list.add(favorite);
    box.add(favorite);
    notifyListeners();
  }

  removeFavorite(FavoriteEntity favorite) {
    list.removeWhere((FavoriteEntity scan) => scan.symbol == favorite.symbol);
    notifyListeners();
  }

  isFavorite(Coin coin) {
    return list.where((favorite) => favorite.symbol == coin.symbol) != null;
  }
}
