import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:provider/provider.dart';
// import 'package:things/providers/things.dart';

import 'package:things/widgets/categories.dart';

import 'package:things/style/colors.dart';

class CategoriesScreen extends StatefulWidget {

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();

}

class _CategoriesScreenState extends State <CategoriesScreen> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: mainDarkBlue,
                    size: 36,
                  ),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F3446)
                  ),
                )
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              new CategoriesDisplay(),
            ],
          ),
        ],
      ),
    );
  }

}