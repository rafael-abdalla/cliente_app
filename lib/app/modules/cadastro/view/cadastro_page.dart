import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/modules/cadastro/controller/cadastro_controller.dart';
import 'package:cliente/app/shared/components/cliente_button.dart';
import 'package:cliente/app/shared/components/cliente_input.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class CadastroPage extends StatelessWidget {
  static const router = '/Cadastro';

  final ClienteModel cliente;

  const CadastroPage(this.cliente, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CadastroController(),
      child: Scaffold(
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = context.read<CadastroController>();
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
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: new ScrollBehavior()
            ..buildViewportChrome(context, null, AxisDirection.down),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Olá,\nFaça o cadastro para continuar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        ClienteInput(
                          label: "Nome",
                          controller: nomeController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return 'Nome obrigatório';

                            return null;
                          },
                        ),
                        ClienteInput(
                          label: "E-mail",
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (!isEmail(value?.toString() ?? ''))
                              return 'E-mail inválido';

                            return null;
                          },
                        ),
                        ClienteInput(
                          label: "Telefone",
                          keyboardType: TextInputType.phone,
                          controller: telefoneController,
                          helperText: "Digite apenas números",
                          validator: (value) {
                            if (!isNumeric(value)) return 'Telefone inválido';

                            return null;
                          },
                        ),
                        ClienteInput(
                          label: "Cep",
                          keyboardType: TextInputType.phone,
                          controller: cepController,
                          helperText: "Digite apenas números",
                          validator: (value) {
                            if (!(isNumeric(value) && (value?.length == 8)))
                              return 'Cep inválido';

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
      ),
    );
  }

  void _enviarCadastro(BuildContext context) {
    if (_formKey.currentState.validate()) {
      context.read<CadastroController>().enviarCadastro(
            ClienteModel(
              codigo: widget.cliente.codigo,
              nome: nomeController.text,
              email: emailController.text,
              telefone: int.parse(telefoneController.text),
              cep: int.parse(cepController.text),
            ),
          );
    }
  }
}
