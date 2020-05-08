import 'package:hive/hive.dart';

part 'wallet.entity.g.dart';

@HiveType(typeId: 1)
class WalletEntity extends HiveObject {
  @HiveField(0)
  String symbol;

  @HiveField(1)
  String name;

  @HiveField(2)
  String address;

  WalletEntity({this.symbol, this.name, this.address});

  @override
  String toString() => "$symbol: $address";
}
