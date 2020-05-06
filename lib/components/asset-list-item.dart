import 'package:Bitalarm/entities/asset.entity.dart';
import 'package:Bitalarm/providers/wallets.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  _removeSelf() {
    var store = Provider.of<WalletsModel>(context, listen: false);
    store.removeAsset(
      widget.asset,
    );
  }

  @override
  Widget build(BuildContext context) {
    var assetName = widget.asset.name.length > 9
        ? widget.asset.name.substring(0, 9)
        : widget.asset.name;

    return Container(
        width: 120,
        child: GestureDetector(
            onLongPress: _removeSelf,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Image.asset(
                      'assets/images/icons/${widget.asset.symbol.toUpperCase()}.png',
                      width: 24,
                    )),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.asset.amount.toStringAsFixed(3),
                      style: _amountStyle),
                  Text(
                    assetName.toUpperCase(),
                    style: _nameStyle,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  )
                ]),
              ],
            )));
  }
}
