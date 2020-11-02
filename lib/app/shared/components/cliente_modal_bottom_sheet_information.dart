import 'package:cliente/app/models/cliente_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cliente_formats.dart';
import 'cliente_rich_text.dart';

class ClienteModalBottomSheetInformation extends Padding {
  ClienteModalBottomSheetInformation(
    BuildContext context,
    ClienteModel cliente,
  ) : super(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Detalhes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              (cliente.caminhoImagem != null &&
                      cliente.caminhoImagem.isNotEmpty)
                  ? Container(
                      height: 250,
                      child: Image.network(cliente.caminhoImagem),
                    )
                  : Container(
                      height: 250,
                      child: Image.asset('assets/images/empty-user.png'),
                    ),
              SizedBox(height: 10),
              ClienteRichText('Nome: ', cliente.nome),
              SizedBox(height: 5),
              ClienteRichText('E-mail: ', cliente.email),
              SizedBox(height: 5),
              ClienteRichText(
                'Telefone: ',
                ClienteFormats().formatarTelefone(cliente.telefone),
              ),
              SizedBox(height: 5),
              ClienteRichText(
                'Cep: ',
                ClienteFormats().formatarCep(cliente.cep),
              ),
            ],
          ),
        );
}
