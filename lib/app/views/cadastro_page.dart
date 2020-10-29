import 'package:cliente/app/controllers/cadastro_controller.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/shared/components/cliente_button.dart';
import 'package:cliente/app/shared/components/cliente_input.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:cliente/app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:firebase_core/firebase_core.dart';

class CadastrarUsuarioPage extends StatelessWidget {
  static const router = '/CadastrarUsuario';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CadastroController(),
      child: CadastrarUsuarioContent(),
    );
  }
}

class CadastrarUsuarioContent extends StatefulWidget {
  @override
  _CadastrarUsuarioContentState createState() =>
      _CadastrarUsuarioContentState();
}

class _CadastrarUsuarioContentState extends State<CadastrarUsuarioContent>
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
    controller.addListener(() async {
      if (this.mounted) {
        exibirLoaderHelper(context, controller.carregando);

        if (!isNull(controller.error))
          exibirErro(context: context, message: controller.error);

        if (controller.cadastroSuccess) {
          Navigator.of(context).pushReplacementNamed(HomePage.router);
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
                          "Nome",
                          controller: nomeController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return 'Nome obrigatório';

                            return null;
                          },
                        ),
                        ClienteInput(
                          "Sobrenome",
                          controller: sobrenomeController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return 'Sobrenome obrigatório';

                            return null;
                          },
                        ),
                        ClienteInput(
                          "Email",
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (!isEmail(value?.toString() ?? ''))
                              return 'E-mail inválido';

                            return null;
                          },
                        ),
                        ClienteInput(
                          "Telefone",
                          keyboardType: TextInputType.phone,
                          controller: telefoneController,
                          helperText: "Digite apenas números",
                          validator: (value) {
                            if (!isNumeric(value)) return 'Telefone inválido';

                            return null;
                          },
                        ),
                        ClienteInput(
                          "Cep",
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
                          onPressed: () => _salvarCliente(context),
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

  void _salvarCliente(BuildContext context) {
    if (_formKey.currentState.validate()) {
      context.read<CadastroController>().cadastrarCliente(
            new ClienteModel(
              nome: nomeController.text,
              sobrenome: sobrenomeController.text,
              email: emailController.text,
              telefone: int.parse(telefoneController.text),
              cep: int.parse(telefoneController.text),
            ),
          );
    }
  }
}
