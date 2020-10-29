import 'package:cliente/app/models/cliente_model.dart';
import 'package:flutter/material.dart';

class ClienteController extends ChangeNotifier {
  Set<ClienteModel> clientes = {};

  void adicionaCliente(ClienteModel clienteObj) {
    clientes.add(clienteObj);
    notifyListeners();
  }
}
