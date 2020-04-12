import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/entities/wallet.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:Bitalarm/screens/favorites/favorites.screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:Bitalarm/providers/favorites.provider.dart';
import 'package:Bitalarm/entities/favorite.entity.dart';
import 'package:nav_router/nav_router.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteEntityAdapter());
  Hive.registerAdapter(WalletEntityAdapter());
  Hive.registerAdapter(AssetEntityAdapter());
  await Hive.openBox<FavoriteEntity>('favorites');
  await Hive.openBox<WalletEntity>('wallets');
  await Hive.openBox<AssetEntity>('assets');
  runApp(BitAlarm());
}

class BitAlarm extends StatefulWidget {
  @override
  State createState() => BitAlarmState();
}

class BitAlarmState extends State<BitAlarm> {
  BitAlarmState();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FavoritesModel>(
              create: (_) => FavoritesModel()),
          ChangeNotifierProvider<WalletsModel>(create: (_) => WalletsModel()),
        ],
        child: MaterialApp(
          title: 'BitAlarm',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColorDark: Colors.black87,
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          home: FavoritesScreen(),
          navigatorKey: navGK,
        ));
  }
}
