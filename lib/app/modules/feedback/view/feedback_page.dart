import 'package:cliente/app/modules/feedback/controller/feedback_controller.dart';
import 'package:cliente/app/shared/components/cliente_button.dart';
import 'package:cliente/app/shared/components/cliente_input.dart';
import 'package:cliente/app/shared/mixins/loader_mixin.dart';
import 'package:cliente/app/shared/mixins/mensagens_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:validators/validators.dart';

class FeedbackPage extends StatelessWidget {
  static const router = '/Feedback';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => FeedbackController(),
        child: FeedbackContent(),
      ),
    );
  }
}

class FeedbackContent extends StatefulWidget {
  @override
  _FeedbackContentState createState() => _FeedbackContentState();
}

class _FeedbackContentState extends State<FeedbackContent>
    with LoaderMixin, MensagensMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textoController = TextEditingController();
  final avaliacao = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    final controller = context.read<FeedbackController>();
    controller.addListener(() {
      exibirLoaderHelper(context, controller.carregando);

      if (!isNull(controller.erro))
        exibirErro(message: controller.erro, context: context);

      if (controller.envioSucesso) {
        exibirSucesso(message: 'Feedback enviado', context: context);
        Future.delayed(Duration(seconds: 1), () => Navigator.of(context).pop());
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
      body: ScrollConfiguration(
        behavior: new ScrollBehavior()
          ..buildViewportChrome(context, null, AxisDirection.down),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5),
                Text(
                  'Feedback',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Ajude a melhorar o aplicativo enviando uma breve avaliação.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ValueListenableBuilder(
                    valueListenable: avaliacao,
                    builder: (_, avaliacaoValue, child) {
                      return RatingBar(
                        maxRating: 5,
                        onRatingChanged: (rating) => avaliacao.value = rating,
                        filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        halfFilledIcon: Icons.star_half,
                        emptyColor: Theme.of(context).primaryColor,
                        isHalfAllowed: true,
                        filledColor: Theme.of(context).primaryColor,
                        size: 36,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ClienteInput(
                    controller: _textoController,
                    hintText: 'Descreva suas impressões',
                    lines: 6,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Texto obrigatório';

                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ClienteButton(
                  'Enviar',
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  buttonColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  textStyle: TextStyle(fontSize: 16),
                  onPressed: () => _enviarFeedback(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _enviarFeedback(BuildContext context) {
    if (_formKey.currentState.validate()) {
      context
          .read<FeedbackController>()
          .enviarFeedback(avaliacao.value, _textoController.text);
    }
  }
}
