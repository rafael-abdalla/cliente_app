import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  bool _carregando = false;
  bool _inativarSucesso = false;
  String _erro = '';
  final _repository = ClienteRepository();

  bool get carregando => _carregando;
  bool get inativarSucesso => _inativarSucesso;
  String get erro => _erro;

  Stream<List<ClienteModel>> listarClientes() {
    return _repository.listarClientes();
  }

  void inativarCadastro(String codigo) async {
    _carregando = true;
    _inativarSucesso = false;
    notifyListeners();
    try {
      await _repository.inativarCadastro(codigo);
      _carregando = false;
      _inativarSucesso = true;
    } on FirestoreException catch (e) {
      _carregando = false;
      _inativarSucesso = false;
      _erro = e.message;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
