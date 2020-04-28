import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/global.dart';
import 'package:things/providers/auth.dart';
import 'package:things/providers/settings.dart';

// import 'package:things/screens/splash.dart';
import 'package:things/screens/loading.dart';
import 'package:things/screens/welcome.dart';
import 'package:things/screens/auth/login.dart';
import 'package:things/screens/auth/register.dart';
import 'package:things/sidebar/sidebar_layout.dart';
import 'package:things/style/colors.dart';

void main() => runApp(new TinyThings ());

class TinyThings extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: new Global(),
        ),
        ChangeNotifierProvider.value(
          value: new Auth(),
        ),
        ChangeNotifierProvider.value(
          value: new Settings(),
        )
      ],
      child: Consumer <Global> (
        builder: (ctx, global, _) => Platform.isAndroid ? MaterialApp (
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
          home: Consumer <Auth> (
            // builder: (ctx, auth, _) => Provider.of<Global>(ctx, listen: false).firstTime ? new WelcomeScreen()
            builder: (ctx, auth, _) => auth.isAuth ? new SideBarLayout () :
                FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState == ConnectionState.waiting ?
                      new LoadingScreen () : new LoginScreen (),
                ),
          ),

          routes: {
            // '/splash': (ctx) => new SplashScreen (),

            '/register': (ctx) => new RegisterScreen (),
          },

          debugShowCheckedModeBanner: true,
        )

        :

        CupertinoApp (
          title: 'Tiny Things',
          theme: CupertinoThemeData (
            // primaryColor: Colors.blue,
            // primaryContrastingColor: Colors.redAccent,
            textTheme: CupertinoTextThemeData (
              textStyle: TextStyle (
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            )
          ),
          // home: HomePage ()
          home: new LoginScreen ()
        )
      ),
    );

	}

}