import 'package:flutter/material.dart';

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

class HomeScreen extends StatelessWidget {

  static const routename = '/home';

  @override
  Widget build(BuildContext context) {

    return Scaffold (
      appBar: AppBar (
        title: const Text ('Tiny Things')
      ),
      // drawer: AppDrawer (),
      body: Container (),
    );

  }

}