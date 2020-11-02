import 'dart:convert';

import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/modules/cadastro/view/cadastro_page.dart';
import 'package:cliente/app/modules/home/controller/home_controller.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:cliente/app/shared/components/cliente_circular_progress_indicator.dart';
import 'package:cliente/app/shared/components/cliente_container_information.dart';
import 'package:cliente/app/shared/components/cliente_modal_bottom_sheet_information.dart';
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
                              SizedBox(height: 5),
                              Text(
                                'Resultados para "${widget.pesquisa}"',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 10),
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

  void _editarCadastro(ClienteModel clienteObj) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage(clienteObj)),
    );
  }

  void _inativarCadastro(ClienteModel clienteObj) {
    controller?.inativarCadastro(clienteObj.docId);
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
}
