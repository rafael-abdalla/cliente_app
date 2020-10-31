import 'package:cliente/app/exceptions/firestore_exception.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteRepository {
  final CollectionReference _clientesCollection =
      FirebaseFirestore.instance.collection('clientes');

  Future<void> novoCadastro(ClienteModel clienteModel) async {
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
      throw FirestoreException('Falha ao carregar os clientes!');
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

  Future<void> inativarCadastro(String codigo) async {
    try {
      await _clientesCollection.doc(codigo).update({'ativo': false});
    } catch (e) {
      print(e);
      throw FirestoreException('Falha ao inativar cliente!');
    }
  }

  Stream<List<ClienteModel>> buscarPorNome(String pesquisa) {
    try {
      Stream<QuerySnapshot> stream =
          _clientesCollection.where("ativo", isEqualTo: true).snapshots();

      return stream.map((QuerySnapshot query) => query.docs
          .map((doc) => ClienteModel.fromFirestore(doc))
          .where((c) => c.nome.toLowerCase().contains(pesquisa.toLowerCase()))
          .toList());
    } on Exception catch (e) {
      print(e);
      throw FirestoreException('Falha ao buscar os clientes!');
    }
  }
}
