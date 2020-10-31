import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class MensagensMixin {
  final scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  exibirErro({
    @required String message,
    BuildContext context,
    GlobalKey<ScaffoldState> key,
  }) =>
      _exibirSnackBar(
        context: context,
        message: message,
        key: key,
        color: Colors.red,
      );

  exibirSucesso({
    @required String message,
    BuildContext context,
    GlobalKey<ScaffoldState> key,
  }) =>
      _exibirSnackBar(
          context: context, message: message, key: key, color: Colors.green);

  void _exibirSnackBar(
      {BuildContext context,
      String message,
      GlobalKey<ScaffoldState> key,
      Color color}) {
    final snackbar = SnackBar(backgroundColor: color, content: Text(message));

    if (key != null)
      key.currentState.showSnackBar(snackbar);
    else
      Scaffold.of(context).showSnackBar(snackbar);
  }
}
