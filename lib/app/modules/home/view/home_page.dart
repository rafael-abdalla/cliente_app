import 'package:cliente/app/modules/ajuda/view/ajuda_page.dart';
import 'package:cliente/app/modules/home/controller/home_controller.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/models/controls/opcao_model.dart';
import 'package:cliente/app/modules/cadastro/view/cadastro_page.dart';
import 'package:cliente/app/modules/feedback/view/feedback_page.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
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
            icon: Icon(FontAwesome.user_plus),
            onPressed: () =>
                Navigator.of(context).pushNamed(CadastroPage.router),
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesome.search),
            onPressed: () {},
          ),
          PopupMenuButton(
            elevation: 0,
            icon: Icon(FontAwesome.ellipsis_v),
            tooltip: 'Mais',
            onSelected: (OpcaoModel opcao) =>
                _selecionarCadastro(opcao.descricao),
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
                        SizedBox(height: 10),
                        ListView.builder(
                          itemCount: clientes.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _buildContainer(context, clientes[index]);
                          },
                        ),
                      ],
                    ),
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

  void _selecionarCadastro(String opcaoSelecionada) {
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
    controller?.inativarCadastro(clienteObj.codigo);
  }
}
