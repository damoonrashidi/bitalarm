import 'package:hive/hive.dart';

part 'asset.entity.g.dart';

@HiveType(typeId: 2)
class AssetEntity extends HiveObject {
  @HiveField(0)
  String symbol;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  AssetEntity({this.symbol, this.name, this.amount});

  @override
  String toString() => "$symbol - $name: $amount";
}
