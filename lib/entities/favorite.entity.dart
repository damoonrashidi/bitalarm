import 'package:hive/hive.dart';

part 'favorite.entity.g.dart';

@HiveType(typeId: 0)
class FavoriteEntity extends HiveObject {
  @HiveField(0)
  String symbol;

  @HiveField(1)
  String name;

  FavoriteEntity({this.symbol, this.name});
  FavoriteEntity.fromJSON(dynamic json) {
    symbol = json['symbol'];
    name = json['name'];
  }

  @override
  String toString() => "$symbol - $name";
}
