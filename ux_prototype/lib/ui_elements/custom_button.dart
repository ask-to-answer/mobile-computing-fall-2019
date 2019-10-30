

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function() onPressed;
  const CustomButton({this.color, this.onPressed, this.text, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = this.color==null?Theme.of(context).accentColor:this.color;
    return Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: color, width: 4)
        ),
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
        child: Text(
          this.text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16
          )
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}