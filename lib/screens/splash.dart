import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/global.dart';
import 'package:things/providers/things.dart';
import 'package:things/providers/settings.dart';

class SplashScreen extends StatefulWidget {

  static const routeName = '/splash';

  // final VoidCallback onInitializationComplete;

  const SplashScreen({
    Key key,
    // @required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initializeAsyncDependencies();
  }

  Future <void> _initializeAsyncDependencies() async {
    // try {
      var global = Provider.of<Global>(context, listen: false);
      var things = Provider.of<Things>(context, listen: false); 

      global.loadGlobal().then((_) async {
        if (global.firstTime) {
          print('First!');
          await things.addCategory(
            'All',
            'All things'
          );
        }

        else {
          await things.loadCategories();
        }
      });
      
      await Provider.of<Settings>(context, listen: false).loadSettings();
    // }

    // catch (error) {
    //   print('Error!');
    // }

    Future.delayed(
      Duration(milliseconds: 2000),
      // () => widget.onInitializationComplete(),
      () => Navigator.of(context).pop()
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 248, 253, 1),
      // backgroundColor: const Color.fromRGBO(47, 54, 64, 1),
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Center(
            child: new Container(
              padding: const EdgeInsets.all(32),
              child: new Image.asset('assets/ermiry.png')
            )
          )
        ],
      )
    );
  }
}