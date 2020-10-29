import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class LoaderMixin {
  bool loaderOpen = false;

  exibirLoaderHelper(BuildContext context, bool condicao) {
    if (condicao)
      exibirLoader(context);
    else
      ocultarLoader(context);
  }

  exibirLoader(BuildContext context) {
    if (context == null) return;

    if (!loaderOpen) {
      loaderOpen = true;
      return Future.delayed(
        Duration.zero,
        () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return Container(
                width: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Carregando...'),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  ocultarLoader(BuildContext context) {
    if (context != null && loaderOpen) {
      loaderOpen = false;
      Navigator.of(context).pop();
    }
  }
}
