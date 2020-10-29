import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CadastrarUsuarioPage extends StatelessWidget {
  static const router = '/CadastrarUsuario';

  @override
  Widget build(BuildContext context) {
    return CadastrarUsuarioContent();
  }
}

class CadastrarUsuarioContent extends StatelessWidget {
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
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Nome"),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Sobrenome"),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Telefone",
                            helperText: "Digite apenas números",
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Cep",
                            helperText: "Digite apenas números",
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              'Salvar',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {},
                          ),
                        )
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
}
