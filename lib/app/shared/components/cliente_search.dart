import 'dart:convert';

import 'package:cliente/app/modules/pesquisa/view/pesquisa_resultado_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClienteSearch extends SearchDelegate<String> {
  List sugestoes;

  ClienteSearch({this.sugestoes});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.length > 0
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => query = "",
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List sugestaoFiltro;

    if (sugestoes != null) {
      sugestaoFiltro = query.isEmpty
          ? sugestoes
          : sugestoes.where((s) => s.startsWith(query)).toList();
    }

    return sugestaoFiltro != null
        ? ListView.builder(
            itemCount: sugestaoFiltro.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.query_builder),
              title: RichText(
                text: TextSpan(
                  text: sugestaoFiltro[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: sugestaoFiltro[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              trailing: Icon(Icons.north_west),
            ),
          )
        : Container();
  }

  @override
  void showResults(BuildContext context) async {
    if (query.isEmpty) return;

    final sharedPreferences = await SharedPreferences.getInstance();

    if (sugestoes != null) {
      sugestoes = jsonDecode(sharedPreferences.getString('buscas'));
    } else {
      sugestoes = List();
    }

    var verificaSugestao =
        sugestoes.firstWhere((x) => x == query, orElse: () => null);
    if (verificaSugestao == null) sugestoes.add(query);

    sharedPreferences.setString('buscas', jsonEncode(sugestoes));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PesquisaResultadoPage(query)),
    );
  }

  @override
  String get searchFieldLabel => "Pesquisar";
}
