import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClienteCircularProgressIndicator extends Center {
  ClienteCircularProgressIndicator(
    Color color,
  ) : super(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(color),
          ),
        );
}
