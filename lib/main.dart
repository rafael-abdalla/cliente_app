import 'package:cliente/app/views/cadastrar_usuario_parge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/views/home_page.dart';
import 'app/views/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Cliente',
      theme: ThemeData(
        textTheme: GoogleFonts.archivoTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Color(0xff2541b2),
      ),
      initialRoute: SplashPage.router,
      routes: {
        SplashPage.router: (_) => SplashPage(),
        HomePage.router: (_) => HomePage(),
        CadastrarUsuarioPage.router: (_) => CadastrarUsuarioPage(),
      },
    );
  }
}
