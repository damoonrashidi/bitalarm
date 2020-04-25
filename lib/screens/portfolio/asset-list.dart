import 'package:Bitalarm/components/asset-list-item.dart';
import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssetList extends StatefulWidget {
  AssetList();

  @override
  State<StatefulWidget> createState() => AssetListState();
}

class AssetListState extends State<AssetList> {
  List<AssetEntity> assets = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var store = Provider.of<WalletsModel>(context);
    assets = store.assets;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var assetsWidgets =
        assets.map((asset) => AssetListItem(asset: asset)).toList();

    print(assets);

    return Row(children: assetsWidgets);
  }
}
