import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClienteRichText extends RichText {
  ClienteRichText(
    String campo,
    String descricao,
  ) : super(
          text: TextSpan(
            text: campo,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: descricao,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
}
