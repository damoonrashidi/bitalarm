import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:flutter/material.dart';

class AssetListItem extends StatelessWidget {
  final AssetEntity asset;

  AssetListItem({this.asset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(asset.name),
        Text(asset.amount.toStringAsFixed(4)),
      ],
    );
  }
}
