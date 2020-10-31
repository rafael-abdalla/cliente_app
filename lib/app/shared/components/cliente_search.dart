import 'package:cliente/app/modules/pesquisa/view/pesquisa_resultado_page.dart';
import 'package:flutter/material.dart';

class ClienteSearch extends SearchDelegate<String> {
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

  List sugestoes = ['Item 1', 'Item 2'];

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: sugestoes.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.query_builder),
        title: Text(sugestoes[index]),
        trailing: Icon(Icons.north_west),
      ),
    );
  }

  @override
  void showResults(BuildContext context) {
    if (query.isEmpty)
      return;
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PesquisaResultadoPage(query)),
      );
    }
  }

  @override
  String get searchFieldLabel => "Pesquisar";
}
