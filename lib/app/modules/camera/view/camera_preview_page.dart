import 'dart:io';
import 'package:cliente/app/modules/cadastro/controller/cadastro_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class CameraPreviewPage extends StatelessWidget {
  final String caminhoImagem;
  final CadastroController controller;

  const CameraPreviewPage(
    this.caminhoImagem,
    this.controller, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CadastroController(),
      child: Scaffold(
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(FontAwesome.check),
          onPressed: () => _enviarFoto(context),
        ),
        body: CameraPreviewContent(caminhoImagem),
      ),
    );
  }

  void _enviarFoto(BuildContext context) {
    controller.salvarFotoPerfil(caminhoImagem);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}

class CameraPreviewContent extends StatelessWidget {
  final String caminhoImagem;

  const CameraPreviewContent(
    this.caminhoImagem, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.file(
        File(caminhoImagem),
        fit: BoxFit.cover,
      ),
    );
  }
}
