import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AjudaPage extends StatelessWidget {
  static const router = '/Ajuda';

  @override
  Widget build(BuildContext context) {
    return AjudaContent();
  }
}

class AjudaContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            FontAwesome.arrow_left,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 5),
              Text(
                'Ajuda',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'O texto abaixo tem o objetivo de explicar as funcionalidades do aplicativo.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 14),
              _textoAjuda('Campos com * são obrigatórios'),
              _textoAjuda('Campos com * são obrigatórios'),
              _textoAjuda('Campos com * são obrigatórios'),
            ],
          ),
        ),
      ),
    );
  }

  Text _textoAjuda(String texto) {
    return Text(
      'Campos com * são obrigatórios\n',
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
