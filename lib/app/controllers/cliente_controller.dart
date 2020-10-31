import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';

class ClienteController extends ChangeNotifier {
  ClienteModel _cliente = ClienteModel();

  bool _carregando = false;
  bool _cadastroSucesso = false;
  bool _edicaoSucesso = false;
  String _erro = '';
  final _repository = ClienteRepository();

  ClienteModel get cliente => _cliente;
  bool get carregando => _carregando;
  bool get cadastroSucesso => _cadastroSucesso;
  bool get edicaoSucesso => _edicaoSucesso;
  String get erro => _erro;
  bool get editando => (_cliente.codigo != null);

  Future<void> cadastrarCliente(ClienteModel clienteObj) async {
    _carregando = true;
    _cadastroSucesso = false;
    notifyListeners();
    try {
      await _repository.cadastrarCliente(clienteObj);
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

  Stream<List<ClienteModel>> listarClientes() {
    return _repository.listarClientes();
  }

  void limparDadosCliente() {
    _carregando = false;
    _cadastroSucesso = false;
    _edicaoSucesso = false;
    _erro = '';
    _cliente = ClienteModel();
    notifyListeners();
  }

  void editarCadastro(ClienteModel clienteObj) async {
    _carregando = true;
    _edicaoSucesso = false;
    notifyListeners();
    try {
      await _repository.editarCadastro(_cliente);
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
