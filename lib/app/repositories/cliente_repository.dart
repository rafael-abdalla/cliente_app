import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteRepository {
  final CollectionReference _clientesCollection =
      FirebaseFirestore.instance.collection('clientes');

  Future<void> cadastrarCliente(ClienteModel clienteModel) async {
    try {
      await _clientesCollection.add(clienteModel.toMap());
    } on Exception catch (e) {
      print(e);
      throw FirestoreException('Falha ao salvar os dados!');
    }
  }

  Stream<List<ClienteModel>> listarClientes() {
    try {
      Stream<QuerySnapshot> stream =
          _clientesCollection.where("ativo", isEqualTo: true).snapshots();

      return stream.map(
        (QuerySnapshot query) => query.docs
            .map(
              (doc) => ClienteModel.fromFirestore(doc),
            )
            .toList(),
      );
    } on Exception catch (e) {
      print(e);
      throw FirestoreException('Falha ao exibir os clientes!');
    }
  }

  Future<void> editarCadastro(ClienteModel clienteModel) async {
    try {
      await _clientesCollection
          .doc(clienteModel.codigo)
          .set(clienteModel.toMap());
    } catch (e) {
      print(e);
      throw FirestoreException('Falha ao editar os dados!');
    }
  }
}
