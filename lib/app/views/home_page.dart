import 'package:cliente/app/controllers/cliente_controller.dart';
import 'package:cliente/app/models/cliente_model.dart';
import 'package:cliente/app/repositories/cliente_repository.dart';
import 'package:cliente/app/views/cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const router = '/Home';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ClienteController(),
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  ClienteController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<ClienteController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cliente App'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesome.user_plus),
            onPressed: () =>
                Navigator.of(context).pushNamed(CadastrarUsuarioPage.router),
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesome.search),
            onPressed: () {},
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(FontAwesome.ellipsis_v),
            onPressed: () {},
          ),
          SizedBox(width: 5),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => ClienteController(),
        child: StreamBuilder(
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
      ),
    );
  }

  Widget _buildContainer(BuildContext context, ClienteModel clienteObj) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(8),
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
                  onPressed: () {},
                ),
                Container(
                  height: 30,
                  width: 0.3,
                  color: Colors.grey,
                ),
                IconButton(
                  color: Colors.red,
                  icon: Icon(FontAwesome.trash),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
