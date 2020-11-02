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
import 'package:cliente/app/shared/components/cliente_message_error.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class HomePage extends StatelessWidget {
  static const router = '/Home';

  final List<OpcaoModel> _opcoes = [
    OpcaoModel(descricao: 'Feedback'),
    OpcaoModel(descricao: 'Ajuda'),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: Scaffold(
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
              onSelected: (OpcaoModel opcao) =>
                  _selecionarOpcao(context, opcao.descricao),
              itemBuilder: (BuildContext context) {
                return _opcoes.map((OpcaoModel opcao) {
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
        body: HomeContent(),
      ),
    );
  }

  void _selecionarOpcao(BuildContext context, String opcaoSelecionada) {
    switch (opcaoSelecionada) {
      case "Feedback":
        Navigator.of(context).pushNamed(FeedbackPage.router);
        break;
      case "Ajuda":
        Navigator.of(context).pushNamed(AjudaPage.router);
        break;
    }
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller?.listarClientes(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return ClienteMessageError(
            ':(\nNão foi possível carregar os dados\nTente mais tarde',
          );
        } else {
          List<ClienteModel> clientes = snapshot.data;

          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: (clientes.length > 0)
                      ? Column(
                          children: [
                            SizedBox(height: 5),
                            ...clientes.map<Widget>(
                              (cliente) => ClienteContainerInformation(
                                MediaQuery.of(context).size.width,
                                cliente,
                                () => _editarCadastro(cliente),
                                () => _inativarCadastro(cliente),
                                () => _informacoesModalBottomSheet(
                                    context, cliente),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClienteMessageError(
                                'Nenhum cliente cadastrado',
                              ),
                              SizedBox(height: 3),
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Ajuda',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(AjudaPage.router),
                              )
                            ],
                          ),
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
