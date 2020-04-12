import 'package:flutter/material.dart';

enum SortProperty { PRICE, GAIN, LOSS }

TextStyle activeStyle = TextStyle(color: Colors.white);
TextStyle inactiveStyle = TextStyle(color: Colors.black);

class SortButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final bool active;

  SortButton(this.label, {this.onPressed, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x333333),
              spreadRadius: 4,
              blurRadius: 4,
            )
          ],
          borderRadius: BorderRadius.circular(48),
          color: active ? Colors.blue : Colors.white,
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(24, 6, 24, 6),
            child: Text(label, style: active ? activeStyle : inactiveStyle)),
      ),
    );
  }
}

class SortButtonGroup extends StatelessWidget {
  final Function onSort;
  final SortProperty active;

  SortButtonGroup({this.onSort, this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SortButton("Price", active: active == SortProperty.PRICE,
            onPressed: () {
          onSort(SortProperty.PRICE);
        }),
        SortButton("Gain", active: active == SortProperty.GAIN, onPressed: () {
          onSort(SortProperty.GAIN);
        }),
        SortButton("Loss", active: active == SortProperty.LOSS, onPressed: () {
          onSort(SortProperty.LOSS);
        }),
      ],
    );
  }
}
