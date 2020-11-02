import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AjudaPage extends StatelessWidget {
  static const router = '/Ajuda';

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
      body: AjudaContent(),
    );
  }
}

class AjudaContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            _titulo('Campos'),
            _textoAjudo(context, 'Campos com * são obrigatórios'),
            _textoAjudo(context,
                'Campos incorretos ficaram em vermelho durante a digitação'),
            _textoAjudo(context,
                'Enquanto houverem campos incorretos, os dados não poderão ser enviados'),
            SizedBox(height: 10),
            _titulo('Botões'),
            _textoAjudo(
              context,
              'Abre o formulário para o cadastro de cliente',
              icone: FontAwesome.user_plus,
            ),
            _textoAjudo(
              context,
              'Abre a pesquisa de cliente',
              icone: FontAwesome.search,
            ),
            _textoAjudo(
              context,
              'Volta para a tela anterior',
              icone: FontAwesome.arrow_left,
            ),
            _textoAjudo(
              context,
              'Abre a câmera ou captura a foto',
              icone: FontAwesome.camera,
            ),
            _textoAjudo(
              context,
              'Confirma ques está sendo visualizada',
              icone: FontAwesome.check,
            ),
          ],
        ),
      ),
    );
  }

  Container _titulo(String texto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Container _textoAjudo(BuildContext context, String texto, {IconData icone}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: (icone != null)
          ? Row(
              children: [
                Icon(icone),
                SizedBox(width: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    texto,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          : Text(
              texto,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
    );
  }
}
