import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:things/style/colors.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: mainBlue,
      body: Center(
        child: Text('Loading...', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );

  }

}