import 'dart:convert';

import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/modules/cadastro/view/cadastro_page.dart';
import 'package:cliente/app/modules/home/controller/home_controller.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:cliente/app/shared/components/cliente_search.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class PesquisaResultadoPage extends StatelessWidget {
  final String pesquisa;

  const PesquisaResultadoPage(this.pesquisa, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: Scaffold(
        body: PesquisaResultadoContent(pesquisa),
      ),
    );
  }
}

class PesquisaResultadoContent extends StatefulWidget {
  final String pesquisa;

  const PesquisaResultadoContent(this.pesquisa, {Key key}) : super(key: key);

  @override
  _PesquisaResultadoContentState createState() =>
      _PesquisaResultadoContentState();
}

class _PesquisaResultadoContentState extends State<PesquisaResultadoContent>
    with LoaderMixin, MensagensMixin {
  HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    controller.addListener(() async {
      if (this.mounted) {
        exibirLoaderHelper(context, controller.carregando);

        if (!isNull(controller.erro)) {
          exibirErro(context: context, message: controller.erro);
        }

        if (controller.inativarSucesso) {
          exibirSucesso(
              message: "Cliente excluído com sucesso", context: context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            FontAwesome.arrow_left,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            color: Theme.of(context).primaryColor,
            tooltip: 'Pesquisar',
            icon: Icon(FontAwesome.search),
            onPressed: () async {
              final sharedPreferences = await SharedPreferences.getInstance();
              List listSugestoes;
              var buscas = sharedPreferences.getString('buscas');
              if (buscas != null) listSugestoes = jsonDecode(buscas);

              showSearch(
                context: context,
                delegate: ClienteSearch(sugestoes: listSugestoes),
              );
            },
          ),
          SizedBox(width: 5),
        ],
      ),
      body: StreamBuilder(
        stream: ClienteRepository().buscarPorNome(widget.pesquisa),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text(
                ':(\nNão foi possível carregar os dados\nTente mais tarde',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            List<ClienteModel> clientes = snapshot.data;

            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return clientes.length > 0
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Resultados para "${widget.pesquisa}"',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                itemCount: clientes.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return _buildContainer(
                                      context, clientes[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Nenhum resultado encontrado',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                break;
              default:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                );
                break;
            }
          }
        },
      ),
    );
  }

  Widget _buildContainer(BuildContext context, ClienteModel clienteObj) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clienteObj.nome,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Aparecida D´Oeste, SP',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        color: Colors.grey[600],
                        icon: Icon(FontAwesome.pencil),
                        onPressed: () => _editarCadastro(clienteObj),
                      ),
                      Container(
                        height: 30,
                        width: 0.3,
                        color: Colors.grey,
                      ),
                      IconButton(
                        color: Colors.red,
                        icon: Icon(FontAwesome.trash),
                        onPressed: () => _inativarCadastro(clienteObj),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.grey[300],
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Detalhes',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              onTap: () {
                print('abrir dialog contendo todas as informações do cliente');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editarCadastro(ClienteModel clienteObj) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage(clienteObj)),
    );
  }

  void _inativarCadastro(ClienteModel clienteObj) {
    controller?.inativarCadastro(clienteObj.docId);
  }
}
