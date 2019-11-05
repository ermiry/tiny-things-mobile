import 'package:flutter/material.dart';

import 'package:things/screens/homre.dart';

void main() => runApp(TinyThings ());

class TinyThings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp (
      title: 'Tiny Things',
      theme: new ThemeData (
        primarySwatch: Colors.blue,
        accentColor: Colors.redAccent
      ),
      home: new HomeScreen (),
    );

  }

}