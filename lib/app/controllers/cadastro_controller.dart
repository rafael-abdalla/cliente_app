import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';

class CadastroController extends ChangeNotifier {
  bool carregando;
  bool cadastroSuccess;
  String error;
  final _repository = ClienteRepository();

  Future<void> cadastrarCliente(ClienteModel clienteObj) async {
    try {
      await _repository.cadastrarCliente(clienteObj);
      carregando = false;
      cadastroSuccess = true;
    } on FirestoreException catch (e) {
      carregando = false;
      cadastroSuccess = false;
      error = e.message;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
