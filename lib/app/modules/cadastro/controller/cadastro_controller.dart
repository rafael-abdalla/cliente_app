import 'dart:io';
import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:flutter/material.dart';

class CadastroController extends ChangeNotifier {
  String _caminhoImagem = '';
  bool _carregando = false;
  bool _cadastroSucesso = false;
  bool _edicaoSucesso = false;
  bool _inativarSucesso = false;
  String _erro = '';
  final _repository = ClienteRepository();

  String get caminhoImagem => _caminhoImagem;
  bool get carregando => _carregando;
  bool get cadastroSucesso => _cadastroSucesso;
  bool get edicaoSucesso => _edicaoSucesso;
  bool get inativarSucesso => _inativarSucesso;
  String get erro => _erro;

  void salvarFotoPerfil(String caminho) {
    _caminhoImagem = caminho;
    notifyListeners();
  }

  void enviarCadastro(ClienteModel clienteObj) {
    if (clienteObj.docId == null) {
      clienteObj.caminhoImagem = caminhoImagem;
      novoCadastro(clienteObj);
    } else {
      bool fotoPerfilAlterada = caminhoImagem.isNotEmpty;
      if (fotoPerfilAlterada) clienteObj.caminhoImagem = caminhoImagem;
      editarCadastro(clienteObj, fotoPerfilAlterada: fotoPerfilAlterada);
    }
  }

  Future<void> novoCadastro(ClienteModel clienteObj) async {
    _carregando = true;
    _cadastroSucesso = false;
    notifyListeners();
    try {
      if (clienteObj.caminhoImagem.isNotEmpty) {
        clienteObj.caminhoImagem = await _repository.enviarFotoPerfil(
            File(caminhoImagem), clienteObj.codigo);
      }

      await _repository.novoCadastro(clienteObj);
      _carregando = false;
      _cadastroSucesso = true;
    } catch (e) {
      _carregando = false;
      _cadastroSucesso = false;
      _erro = e.message;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> editarCadastro(ClienteModel clienteObj,
      {bool fotoPerfilAlterada = false}) async {
    _carregando = true;
    _edicaoSucesso = false;
    notifyListeners();
    try {
      if (fotoPerfilAlterada) {
        clienteObj.caminhoImagem = await _repository.enviarFotoPerfil(
            File(caminhoImagem), clienteObj.codigo);
      }

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
