import 'dart:async';
import 'package:flutter/material.dart';
import '../../home/view/home_page.dart';

class SplashPage extends StatelessWidget {
  static const router = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashContent());
  }
}

class SplashContent extends StatefulWidget {
  @override
  _SplashContentState createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.router, (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Theme.of(context).primaryColor,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Carregando...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
