import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteModel {
  String nome;
  String sobrenome;
  String email;
  int telefone;
  int cep;
  bool ativo;
  int dataCadastro;

  ClienteModel({
    this.nome,
    this.sobrenome,
    this.email,
    this.telefone,
    this.cep,
    this.ativo = true,
    this.dataCadastro,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'sobrenome': sobrenome,
      'email': email,
      'telefone': telefone,
      'cep': cep,
      'ativo': ativo,
      'dataCadastro': Timestamp.now().microsecondsSinceEpoch,
    };
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ClienteModel(
      nome: map['nome'],
      sobrenome: map['sobrenome'],
      email: map['email'],
      telefone: map['telefone'],
      cep: map['cep'],
      ativo: map['ativo'],
      dataCadastro: map['dataCadastro'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClienteModel.fromJson(String source) =>
      ClienteModel.fromMap(json.decode(source));
}
