import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/global.dart';
import 'package:things/providers/ui.dart';
import 'package:things/providers/auth.dart';
import 'package:things/providers/things.dart';
import 'package:things/providers/settings.dart';

import 'package:things/screens/splash.dart';
import 'package:things/screens/welcome.dart';
import 'package:things/screens/loading.dart';
import 'package:things/screens/auth/login.dart';
import 'package:things/screens/auth/register.dart';
import 'package:things/screens/drawer.dart';
import 'package:things/screens/active.dart';

import 'package:things/style/colors.dart';

void main() => runApp(new TinyThings ());

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          ActiveScreen(),
        ],
      ),
    );
  }
}

class TinyThings extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: new Global()),
        ChangeNotifierProvider.value(value: new UI()),
        ChangeNotifierProvider.value(value: new Auth()),
        ChangeNotifierProvider.value(value: new Things()),
        ChangeNotifierProvider.value(value: new Settings())
      ],
      child: Consumer <Global> (
        builder: (ctx, global, _) => MaterialApp (
          title: 'Tiny Things',
          theme: ThemeData (
            splashColor: mainBlue,
            primaryColor: mainBlue,
            fontFamily: 'Quicksand',
            appBarTheme: AppBarTheme (
              textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle (fontFamily: 'Open Sans', fontSize: 20, fontWeight: FontWeight.bold)
                )
            ),
            textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle (
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              button: TextStyle (
                color: Colors.white
              )
            )
          ),
          initialRoute: '/splash',
          home: Consumer <Auth> (
            builder: (ctx, auth, _) => global.firstTime ? new WelcomeScreen() 
              :
              auth.isAuth ? new MainScreen () :
                FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState == ConnectionState.waiting ?
                      new LoadingScreen () : new LoginScreen (),
                ),
          ),

          routes: {
            '/splash': (ctx) => new SplashScreen (),

            '/register': (ctx) => new RegisterScreen (),
          },

          debugShowCheckedModeBanner: true,
        )
      ),
    );

	}

}