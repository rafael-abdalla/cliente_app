import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteModel {
  String docId;
  int codigo;
  String caminhoImagem;
  String nome;
  String email;
  int telefone;
  int cep;
  bool ativo;
  int dataCadastro;

  ClienteModel({
    this.docId,
    this.codigo,
    this.caminhoImagem,
    this.nome,
    this.email,
    this.telefone,
    this.cep,
    this.ativo = true,
    this.dataCadastro,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'caminhoImagem': caminhoImagem,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cep': cep,
      'ativo': ativo,
      'dataCadastro': Timestamp.now().microsecondsSinceEpoch,
    };
  }

  factory ClienteModel.fromFirestore(DocumentSnapshot doc) {
    if (doc.data() == null) return null;
    Map map = doc.data();

    return ClienteModel(
      docId: doc.id,
      codigo: map['codigo'],
      caminhoImagem: map['caminhoImagem'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      cep: map['cep'],
      ativo: map['ativo'],
      dataCadastro: map['dataCadastro'],
    );
  }

  String toJson() => json.encode(toMap());
}
