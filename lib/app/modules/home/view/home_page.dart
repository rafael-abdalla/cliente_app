import 'dart:convert';

import 'package:cliente/app/modules/ajuda/view/ajuda_page.dart';
import 'package:cliente/app/modules/home/controller/home_controller.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/models/controls/opcao_model.dart';
import 'package:cliente/app/modules/cadastro/view/cadastro_page.dart';
import 'package:cliente/app/modules/feedback/view/feedback_page.dart';
import 'package:cliente/app/shared/components/cliente_circular_progress_indicator.dart';
import 'package:cliente/app/shared/components/cliente_container_information.dart';
import 'package:cliente/app/shared/components/cliente_modal_bottom_sheet_information.dart';
import 'package:cliente/app/shared/components/cliente_search.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class HomePage extends StatelessWidget {
  static const router = '/Home';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: Scaffold(
        body: HomeContent(),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
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

  List<OpcaoModel> opcoes = [
    OpcaoModel(descricao: 'Feedback'),
    OpcaoModel(descricao: 'Ajuda'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('App'),
        actions: [
          IconButton(
            color: Colors.white,
            tooltip: 'Cadastro',
            icon: Icon(FontAwesome.user_plus),
            onPressed: () =>
                Navigator.of(context).pushNamed(CadastroPage.router),
          ),
          IconButton(
            color: Colors.white,
            tooltip: 'Pesquisar',
            icon: Icon(FontAwesome.search),
            onPressed: () async {
              final sharedPreferences = await SharedPreferences.getInstance();
              List listaSugestoes;
              var buscas = sharedPreferences.getString('buscas');
              if (buscas != null) listaSugestoes = jsonDecode(buscas);

              showSearch(
                context: context,
                delegate: ClienteSearch(sugestoes: listaSugestoes),
              );
            },
          ),
          PopupMenuButton(
            elevation: 0,
            icon: Icon(FontAwesome.ellipsis_v),
            tooltip: 'Mais',
            onSelected: (OpcaoModel opcao) => _selecionarOpcao(opcao.descricao),
            itemBuilder: (BuildContext context) {
              return opcoes.map((OpcaoModel opcao) {
                return PopupMenuItem(
                  value: opcao,
                  child: Text(opcao.descricao),
                );
              }).toList();
            },
          ),
          SizedBox(width: 5),
        ],
      ),
      body: StreamBuilder(
        stream: controller?.listarClientes(),
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
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        ...clientes.map<Widget>(
                          (cliente) => ClienteContainerInformation(
                            MediaQuery.of(context).size.width,
                            cliente,
                            () => _editarCadastro(cliente),
                            () => _inativarCadastro(cliente),
                            () =>
                                _informacoesModalBottomSheet(context, cliente),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
                break;
              default:
                return ClienteCircularProgressIndicator(
                  Theme.of(context).primaryColor,
                );
                break;
            }
          }
        },
      ),
    );
  }

  void _informacoesModalBottomSheet(context, ClienteModel cliente) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return ClienteModalBottomSheetInformation(context, cliente);
      },
    );
  }

  void _selecionarOpcao(String opcaoSelecionada) {
    switch (opcaoSelecionada) {
      case "Feedback":
        Navigator.of(context).pushNamed(FeedbackPage.router);
        break;
      case "Ajuda":
        Navigator.of(context).pushNamed(AjudaPage.router);
        break;
    }
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
