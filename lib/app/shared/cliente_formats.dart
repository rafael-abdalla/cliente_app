class ClienteFormats {
  String formatarTelefone(int numero) {
    String texto = numero.toString();

    String dd = texto.substring(0, 2);
    String prefixo = texto.substring(2, 7);
    String sufixo = texto.substring(7, 11);

    return '($dd) $prefixo-$sufixo';
  }

  String formatarCep(int numero) {
    String texto = numero.toString();

    String prefixo = texto.substring(0, 5);
    String sufixo = texto.substring(5, 8);

    return '$prefixo-$sufixo';
  }
}
