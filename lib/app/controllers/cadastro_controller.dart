import 'package:cliente/app/models/cliente_model.dart';
import 'package:flutter/material.dart';

class CadastroController extends ChangeNotifier {
  void cadastrarUsuario(ClienteModel clienteObj) {
    print('${clienteObj.nome} ${clienteObj.sobrenome}');
  }
}
