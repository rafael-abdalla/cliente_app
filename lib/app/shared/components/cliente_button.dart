import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClienteButton extends Container {
  ClienteButton(
    String label, {
    @required double width,
    @required double height,
    TextStyle textStyle,
    double fontSize = 12,
    Function onPressed,
    Color textColor,
    Color buttonColor,
  }) : super(
          width: width,
          height: height,
          child: RaisedButton(
            textColor: textColor,
            color: buttonColor,
            child: Text(
              label,
              style: textStyle ??
                  TextStyle(
                    fontSize: fontSize,
                  ),
            ),
            onPressed: onPressed,
          ),
        );
}
