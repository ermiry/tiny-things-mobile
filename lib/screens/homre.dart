import 'package:flutter/material.dart';

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