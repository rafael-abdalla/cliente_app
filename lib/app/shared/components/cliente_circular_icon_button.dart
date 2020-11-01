import 'package:flutter/material.dart';

class ClienteCircularIconButton extends MaterialButton {
  ClienteCircularIconButton(
    Color color,
    IconData icon, {
    EdgeInsets padding,
    Color textColor,
    Function onPressed,
  }) : super(
          color: color,
          textColor: textColor ?? Colors.white,
          padding: padding ?? EdgeInsets.all(8),
          shape: CircleBorder(),
          child: Icon(icon),
          onPressed: onPressed,
        );
}
