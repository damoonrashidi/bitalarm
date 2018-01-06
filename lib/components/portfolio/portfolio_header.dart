import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../styles.dart';

class PortfolioHeader extends StatefulWidget {

  final double total;
  PortfolioHeader({this.total}) {
    debugPrint(this.total.toString());
  }

  @override
  createState() => new PortfolioHeaderState(total: total);

}

class PortfolioHeaderState extends State<PortfolioHeader> {

  final double total;
  double _stake = 0.0;
  SharedPreferences prefs;
  final TextStyle detailNumberStyle = new TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w200);
  final TextStyle detailExp = new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w900);
  final TextEditingController _stakeCtrl = new TextEditingController();

  PortfolioHeaderState({this.total});

  initStateAsync() async {
    try {
      prefs = await SharedPreferences.getInstance();
      _stake = prefs.getDouble('stake');
      _stakeCtrl.text = _stake.toString();
    } catch (e) {
      prefs.setDouble('stake', 0.0);
      _stake = 0.0;
    }
  }

  @override
  initState() {
    super.initState();
    initStateAsync();
  }

  @override
  Widget build(BuildContext ctx) {
    double profit = total - _stake;
    NumberFormat nf = new NumberFormat("###,###,###");
    // NumberFormat nf = new NumberFormat.currency(locale: 'sv_SE', decimalDigits: 0, symbol: '', name: 'SEK');
    return new ClipPath(
      clipper: new ArcClipper(),
      child: new Container(
        width: 500.0,
        padding: const EdgeInsets.only(top: 20.0),
        decoration: new BoxDecoration(gradient: primaryGradient),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(nf.format(total), style: new TextStyle(color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.w100)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  new Text('STAKE', style: detailExp),
                  new Container(
                    width: 100.0,
                    child: new TextField(
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      controller: _stakeCtrl,
                      onChanged: (String state) {
                      if (state != null && state.length != 0) {
                        _stake = double.parse(state);
                        prefs.setDouble('stake', _stake);
                      }
                      
                    }) 
                  ),
                  // new Text(nf.format(_stake), style: detailNumberStyle),
                ]),
                new Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                  new Text('PROFIT', style: detailExp),
                  new Text(nf.format(profit), style: detailNumberStyle),
                ]),
              ],
            )
          ]
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 15);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstPoint.dx, firstPoint.dy);
    var secondControlPoint =new Offset(size.width - (size.width / 4), size.height);
    var secondPoint = new Offset(size.width, size.height - 15);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondPoint.dx, secondPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}