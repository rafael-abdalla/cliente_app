import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClienteMessageError extends Center {
  ClienteMessageError(
    String texto,
  ) : super(
          child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
        );
}
