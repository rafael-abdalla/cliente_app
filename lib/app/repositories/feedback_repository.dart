import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackRepository {
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedbacks');

  Future<void> enviarFeedback(double avaliacao, String feedback) async {
    try {
      await _feedbackCollection.add({
        'avaliacao': avaliacao,
        'texto': feedback,
        'dataEnvio': Timestamp.now().microsecondsSinceEpoch
      });
    } on Exception catch (e) {
      print(e);
      throw FirestoreException('Falha ao enviar feedback!');
    }
  }
}
