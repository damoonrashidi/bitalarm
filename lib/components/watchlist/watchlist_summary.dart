import 'package:flutter/material.dart';
import '../../styles.dart';

const TextStyle numberStyle = const TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.w100,
  color: Colors.white,
);

const TextStyle labelStyle = const TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  color: Colors.white
);

class WatchlistSummary extends StatelessWidget {
  
  final double average;
  final int winners;
  final int losers;

  WatchlistSummary({this.average, this.winners, this.losers});
  
  @override
  Widget build(BuildContext ctx) {
    return new Container(
      padding: new EdgeInsets.only(top: 40.0),
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new NetworkImage('https://ak9.picdn.net/shutterstock/videos/14513749/thumb/1.jpg'),
          fit: BoxFit.cover,
        ),
        border: const Border(
          bottom: const BorderSide(
            color: const Color(0xffdddddd)
          )
        )
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              new Text(this.average.toStringAsFixed(1) + "%", style: numberStyle),
              new Text('Avg. change', style: labelStyle),
          ]),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              new Text(this.winners.toString(), style: numberStyle),
              new Text('Winners', style: labelStyle),
          ]),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              new Text(this.losers.toString(), style: numberStyle),
              new Text('Losers', style: labelStyle),
          ])
        ],
      ),
    );
  }
}