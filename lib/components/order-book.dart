import 'package:Bitalarm/entities/coin.entity.dart';
import 'package:Bitalarm/entities/orderbook.entity.dart';
import 'package:Bitalarm/services/coin.service.dart';
import 'package:Bitalarm/shared/styles.dart';
import 'package:flutter/material.dart';

class OrderBook extends StatefulWidget {
  final Coin coin;

  OrderBook({this.coin});

  @override
  State<StatefulWidget> createState() => OrderBookState();
}

class OrderBookState extends State<OrderBook> {
  var coinService = CoinService();
  OrderBookModel model = OrderBookModel(asks: [], bids: []);

  @override
  void initState() {
    super.initState();
    _getOrderBook();
  }

  _getOrderBook() async {
    model = await coinService.getOrderBook(widget.coin.symbol);
    setState(() {});
  }

  _makeRows(List<dynamic> bidOrAsk, {Color color = Colors.red}) {
    var list = bidOrAsk;
    var style = TextStyle(color: color, fontSize: 11);

    return list
        .map((boa) => DataRow(cells: [
              DataCell(Text(
                "\$${boa[0]}",
                style: style,
              )),
              DataCell(Text(boa[1].toStringAsFixed(4), style: style)),
            ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var askRows = _makeRows(model.asks, color: COLOR_SOFT_BLUE);
    var bidRows = _makeRows(model.bids, color: COLOR_SOFT_RED);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: DataTable(columns: [
          DataColumn(label: Text("USD")),
          DataColumn(label: Text(widget.coin.symbol))
        ], rows: askRows)),
        Expanded(
            child: DataTable(columns: [
          DataColumn(label: Text("USD")),
          DataColumn(label: Text(widget.coin.symbol))
        ], rows: bidRows))
      ],
    );
  }
}
