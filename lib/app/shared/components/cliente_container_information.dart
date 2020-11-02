import 'package:cliente/app/models/cliente_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ClienteContainerInformation extends Container {
  ClienteContainerInformation(
    double width,
    ClienteModel clienteObj,
    Function editar,
    Function inativar,
    Function detalhes,
  ) : super(
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
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: width * 0.1,
                        child: (clienteObj.caminhoImagem != null &&
                                clienteObj.caminhoImagem.isNotEmpty)
                            ? CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(clienteObj.caminhoImagem),
                              )
                            : CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/empty-user.png'),
                              ),
                      ),
                      Container(
                        width: width * 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clienteObj.nome,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              clienteObj.email,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            color: Colors.grey[600],
                            icon: Icon(FontAwesome.pencil),
                            onPressed: editar,
                          ),
                          Container(
                            height: 30,
                            width: 0.3,
                            color: Colors.grey,
                          ),
                          IconButton(
                            color: Colors.red,
                            icon: Icon(FontAwesome.trash),
                            onPressed: inativar,
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
                  onTap: detalhes,
                ),
              ],
            ),
          ),
        );
}
