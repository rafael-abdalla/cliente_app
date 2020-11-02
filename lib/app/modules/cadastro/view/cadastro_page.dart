import 'dart:io';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/modules/cadastro/controller/cadastro_controller.dart';
import 'package:cliente/app/modules/camera/view/camera_page.dart';
import 'package:cliente/app/shared/components/cliente_button.dart';
import 'package:cliente/app/shared/components/cliente_circular_icon_button.dart';
import 'package:cliente/app/shared/components/cliente_input.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:camera/camera.dart';

class CadastroPage extends StatelessWidget {
  static const router = '/Cadastro';

  final ClienteModel cliente;

  const CadastroPage(this.cliente, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CadastroController(),
      child: Scaffold(
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
        ),
        body: CadastroContent(cliente),
      ),
    );
  }
}

class CadastroContent extends StatefulWidget {
  final ClienteModel cliente;

  const CadastroContent(this.cliente, {Key key}) : super(key: key);

  @override
  _CadastroContentState createState() => _CadastroContentState();
}

class _CadastroContentState extends State<CadastroContent>
    with LoaderMixin, MensagensMixin {
  List<CameraDescription> cameras;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  CadastroController controller;

  Future<Null> carregarCameras() async {
    cameras = await availableCameras();
  }

  @override
  void initState() {
    super.initState();
    carregarCameras();
    controller = context.read<CadastroController>();
    nomeController.text = widget.cliente.nome ?? '';
    emailController.text = widget.cliente.email ?? '';
    telefoneController.text = widget.cliente.telefone?.toString() ?? '';
    cepController.text = widget.cliente.cep?.toString() ?? '';

    controller.addListener(() async {
      if (this.mounted) {
        exibirLoaderHelper(context, controller.carregando);

        if (!isNull(controller.erro)) {
          exibirErro(context: context, message: controller.erro);
        }

        if (controller.cadastroSucesso ||
            controller.edicaoSucesso ||
            controller.inativarSucesso) {
          String mensagem = "";

          if (controller.cadastroSucesso)
            mensagem = "Cliente salvo com sucesso";
          if (controller.edicaoSucesso)
            mensagem = "Alteração salva com sucesso";
          if (controller.inativarSucesso)
            mensagem = "Cliente excluído com sucesso";

          exibirSucesso(message: mensagem, context: context);
          Future.delayed(
            Duration(seconds: 1),
            () => Navigator.of(context).pop(),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: new ScrollBehavior()
          ..buildViewportChrome(context, null, AxisDirection.down),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Olá,\nFaça o cadastro para continuar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Stack(
                  children: [
                    Consumer<CadastroController>(
                      builder: (_, cadastroController, __) {
                        if (cadastroController.caminhoImagem.isNotEmpty) {
                          return CircleAvatar(
                            radius: 70,
                            backgroundImage: FileImage(
                              File(cadastroController.caminhoImagem),
                            ),
                          );
                        } else if (widget.cliente.caminhoImagem != null &&
                            widget.cliente.caminhoImagem.isNotEmpty) {
                          return CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                NetworkImage(widget.cliente.caminhoImagem),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 70,
                            backgroundImage: AssetImage(
                              'assets/images/empty-user.png',
                            ),
                          );
                        }
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: ClienteCircularIconButton(
                        Theme.of(context).primaryColor,
                        FontAwesome.camera,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPage(
                              cameras,
                              controller,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      ClienteInput(
                        label: "Nome *",
                        controller: nomeController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Nome obrigatório';

                          return null;
                        },
                      ),
                      ClienteInput(
                        label: "E-mail *",
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'E-mail obrigatório';
                          else if (!isEmail(value?.toString() ?? ''))
                            return 'E-mail inválido';

                          return null;
                        },
                      ),
                      ClienteInput(
                        label: "Telefone *",
                        keyboardType: TextInputType.phone,
                        controller: telefoneController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Telefone obrigatório';
                          if (!isNumeric(value)) return 'Digite apenas números';

                          return null;
                        },
                      ),
                      ClienteInput(
                        label: "Cep *",
                        keyboardType: TextInputType.phone,
                        controller: cepController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Cep obrigatório';
                          else if (!isNumeric(value))
                            return "Digte apenas números";
                          else if (!(value.length == 8)) return 'Cep inválido';

                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ClienteButton(
                        'Salvar',
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        textStyle: TextStyle(fontSize: 16),
                        onPressed: () => _enviarCadastro(context),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _enviarCadastro(BuildContext context) {
    if (_formKey.currentState.validate()) {
      controller.enviarCadastro(
        ClienteModel(
          docId: widget.cliente.docId,
          codigo:
              widget.cliente.codigo ?? Timestamp.now().microsecondsSinceEpoch,
          nome: nomeController.text,
          email: emailController.text,
          telefone: int.parse(telefoneController.text),
          cep: int.parse(cepController.text),
        ),
      );
    }
  }
}
