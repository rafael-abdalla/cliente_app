import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/views/cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatelessWidget {
  static const router = '/Home';

  @override
  Widget build(BuildContext context) {
    return HomeContent();
  }
}

class HomeContent extends StatelessWidget {
  final List clientes = [
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
    ClienteModel(
        nome: 'Rafael',
        sobrenome: 'Silveira',
        email: 'contato@gmail.com',
        telefone: 17996545718,
        cep: 15735000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cliente App'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesome.user_plus),
            onPressed: () =>
                Navigator.of(context).pushNamed(CadastrarUsuarioPage.router),
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesome.search),
            onPressed: () {},
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesome.ellipsis_v),
            onPressed: () {},
          ),
          SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: clientes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ClienteModel clienteObj = clientes[index];

                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(clienteObj.nome),
                              Text(
                                'Aparecida D´Oeste, SP',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                color: Colors.grey[600],
                                icon: Icon(FontAwesome.pencil),
                                onPressed: () {},
                              ),
                              Container(
                                height: 30,
                                width: 0.3,
                                color: Colors.grey,
                              ),
                              IconButton(
                                color: Colors.red,
                                icon: Icon(FontAwesome.trash),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
