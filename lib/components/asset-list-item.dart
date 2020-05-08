import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:flutter/material.dart';

var _amountStyle = TextStyle(
    fontSize: 23, fontWeight: FontWeight.normal, fontFamily: 'Oswald');
var _nameStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w100,
  color: Colors.white.withOpacity(0.5),
  fontFamily: 'Oswald',
  letterSpacing: 1.5,
);

class AssetListItem extends StatefulWidget {
  final AssetEntity asset;

  AssetListItem({this.asset});

  @override
  _AssetListItemState createState() => _AssetListItemState();
}

class _AssetListItemState extends State<AssetListItem> {
  @override
  Widget build(BuildContext context) {
    var assetName = widget.asset.name.length > 9
        ? widget.asset.name.substring(0, 9)
        : widget.asset.name;

    var nameSum = widget.asset.name
            .split('')
            .map((char) => char.codeUnitAt(0))
            .reduce((value, element) => value + element) *
        100000;
    nameSum.toRadixString(16);
    Color color = Color(nameSum);

    return Container(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(right: 16),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: color.withOpacity(1),
                      borderRadius: BorderRadius.circular(50)),
                )),
            Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    widget.asset.amount.toStringAsFixed(3),
                    style: _amountStyle,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    assetName.toUpperCase(),
                    style: _nameStyle,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  )
                ])),
          ],
        ));
  }
}
