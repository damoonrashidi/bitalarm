import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/entities/favorite.entity.dart';
import 'package:flutter/material.dart';

class FavoritesModel extends ChangeNotifier {
  List<FavoriteEntity> list = [];

  FavoritesModel();

  addFavorite(FavoriteEntity favorite) {
    list.add(favorite);
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
