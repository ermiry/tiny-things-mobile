import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/ui.dart';

import 'package:things/screens/home.dart';
import 'package:things/screens/about.dart';
import 'package:things/screens/account.dart';
import 'package:things/screens/settings.dart';

class ActiveScreen extends StatefulWidget {

	@override
	_ActiveScreenState createState () => _ActiveScreenState ();

}

class _ActiveScreenState extends State <ActiveScreen> {

  Widget body(String screen) {
    Widget retval;
    switch (screen) {
      case "Home": retval = HomeScreen(); break; 
      case "About": retval = AboutScreen(); break;
      case "Account": retval = AccountScreen(); break;
      case "Settings": retval = SettingsScreen(); break;
    }

    return retval;
  }

	@override
	Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Consumer <UI> (
      builder: (ctx, ui, _) => GestureDetector(
        child: AnimatedContainer (
          transform: Matrix4.translationValues(ui.xOffset, ui.yOffset, 0)
            ..scale(ui.scaleFactor, ui.yScaleFactor)..rotateY(ui.isDrawerOpen ? -0.5 : 0),
          duration: Duration(milliseconds: 250),

          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(ui.isDrawerOpen ? 32 : 0.0)
          ),

          child: Container (
            // margin: EdgeInsets.symmetric(horizontal: 32),
            child: ListView(
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                // Row (
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ui.isDrawerOpen ? IconButton(
                //       icon: Icon(Icons.arrow_back_ios),
                //       onPressed: () {
                //         // setState(() {
                //         //   xOffset = 0;
                //         //   yOffset = 0;
                //         //   scaleFactor = 1;
                //         //   isDrawerOpen = false;
                //         // });
                //       },
                //     )

                //     :

                //     IconButton(
                //       icon: Icon(Icons.menu),
                //       onPressed: () {
                //         if (!ui.isDrawerOpen) {
                //           ui.openDrawer();
                //         }
                //       }
                //     ),
                //   ],
                // ),

                this.body(ui.currentScreen)
              ],
            )
          ),
        ),
        onTap: () {
          if (ui.isDrawerOpen) {
            ui.closeDrawer();
          }
        },
      )
    );

	}

}