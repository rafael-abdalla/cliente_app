import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';

class CadastroController extends ChangeNotifier {
  bool _carregando = false;
  bool _cadastroSucesso = false;
  bool _edicaoSucesso = false;
  bool _inativarSucesso = false;
  String _erro = '';
  final _repository = ClienteRepository();

  bool get carregando => _carregando;
  bool get cadastroSucesso => _cadastroSucesso;
  bool get edicaoSucesso => _edicaoSucesso;
  bool get inativarSucesso => _inativarSucesso;
  String get erro => _erro;

  void enviarCadastro(ClienteModel clienteObj) {
    if (clienteObj.codigo == null)
      novoCadastro(clienteObj);
    else
      editarCadastro(clienteObj);
  }

  Future<void> novoCadastro(ClienteModel clienteObj) async {
    _carregando = true;
    _cadastroSucesso = false;
    notifyListeners();
    try {
      await _repository.novoCadastro(clienteObj);
      _carregando = false;
      _cadastroSucesso = true;
    } on FirestoreException catch (e) {
      _carregando = false;
      _cadastroSucesso = false;
      _erro = e.message;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> editarCadastro(ClienteModel clienteObj) async {
    _carregando = true;
    _edicaoSucesso = false;
    notifyListeners();
    try {
      await _repository.editarCadastro(clienteObj);
      _carregando = false;
      _edicaoSucesso = true;
    } on FirestoreException catch (e) {
      _carregando = false;
      _edicaoSucesso = false;
      _erro = e.message;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
