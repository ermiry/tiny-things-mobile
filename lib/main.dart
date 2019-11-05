import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:things/providers/things.dart';

import 'package:things/screens/tabs.dart';

void main() => runApp(TinyThings ());

class TinyThings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider (
      providers: [
        ChangeNotifierProvider.value (
          value: new Things ()
        )
      ],
      child: MaterialApp (
        title: 'Tiny Things',
        theme: new ThemeData (
          primarySwatch: Colors.blue,
          accentColor: Colors.redAccent
        ),
        home: new TabScreen (),
      ),
    );

  }

}