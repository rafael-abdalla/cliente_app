import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/repositories/feedback_repository.dart';
import 'package:flutter/material.dart';

class FeedbackController extends ChangeNotifier {
  bool _carregando = false;
  bool _envioSucesso = false;
  String _erro = '';
  final _repository = FeedbackRepository();

  bool get carregando => _carregando;
  bool get envioSucesso => _envioSucesso;
  String get erro => _erro;

  Future<void> enviarFeedback(String texto) async {
    try {
      await _repository.enviarFeedback(texto);
      _carregando = false;
      _envioSucesso = true;
    } on FirestoreException catch (e) {
      _carregando = false;
      _envioSucesso = false;
      _erro = e.message;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
