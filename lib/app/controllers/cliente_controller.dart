import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';

class ClienteController extends ChangeNotifier {
  String erro;
  final _repository = ClienteRepository();

  Stream<List<ClienteModel>> listarClientes() {
    return _repository.listarClientes();
  }
}
