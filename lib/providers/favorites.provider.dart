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
    /**
     * These functions will be running double duty with adding / removing from current app state
     * and from the stored box state. imo it's an ugly solution internally here, but from it's nice
     * on the consumer side to avoid having knowledge about how the coins are stored in local storage.
     * 
     * If this mantra is kept throughout the app then it should be safe to say that there will be
     * no hive imports anywhere besides services - i.e. the persistance layer is encapsulated in
     * the service so external parts of the applications do not have to concern themselves with
     * persisting state. This could be an anti-pattern, who knows.
     */
    list.add(favorite);
    box.add(favorite);
    notifyListeners();
  }

  removeFavorite(FavoriteEntity favorite) {
    list.removeWhere((FavoriteEntity scan) => scan.symbol == favorite.symbol);
    box.delete(favorite);
    notifyListeners();
  }

  toggleFavorite(FavoriteEntity favorite) {
    /** 
     * We don't actually need a "real" coin here, just enough to check whether or not it is a favorite
     * It's because I made the decision to only pass Coins/Favorites to all functions to keep the internal API
     * sane.
     */
    Coin coin = Coin(name: favorite.name, symbol: favorite.symbol);
    if (isFavorite(coin)) {
      removeFavorite(favorite);
    } else {
      addFavorite(favorite);
    }
  }

  /// Checks to see if a given coin is a favorite or not
  bool isFavorite(Coin coin) {
    var found = list.firstWhere((favorite) => favorite.symbol == coin.symbol,
        orElse: () => null);

    return found != null;
  }
}
