import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/auth.dart';

import 'package:things/models/http_exception.dart';

import 'package:things/style/colors.dart';

import 'package:things/version.dart';

class LoginScreen extends StatefulWidget {

  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState ();

}

class _LoginScreenState extends State <LoginScreen> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  Map <String, String> _authData = {
    // 'username': '',
    'email': '',
    'password': '',
  };

  final FocusNode _passwordFocusNode = new FocusNode ();

  bool _signinLoading = false;

  @override
  void dispose()  {
    this._passwordFocusNode.dispose();

    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Error!', 
          style: const TextStyle(color: Colors.red, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Text (
          message,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainDarkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <void> _login() async {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      try {
        this.setState(() => this._signinLoading = true);
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } on HttpException catch (error) {
        var jsonError = json.decode(error.toString());

        String actualError;
        if (jsonError['email'] != null) actualError = jsonError['email'];
        else if (jsonError['username'] != null) actualError = jsonError['username'];
        else if (jsonError['password'] != null) actualError = jsonError['password'];

        // print(actualError);

        _showErrorDialog(actualError);
      }

      catch (error) {
        _showErrorDialog('Failed to authenticate!');
      }

      finally {
        this.setState(() => this._signinLoading = false);
      }
    }
  } 

  void _info() {
    showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0)
        ),
      ),
      builder: (bCtx) => new Container (
        height: MediaQuery.of(context).size.height * 0.2,
        padding: EdgeInsets.all(16),
        child: new Center(
          child: new Column(
            children: <Widget>[
              Text(
                'Tiny Things Mobile App',
                style: new TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mainDarkBlue),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'Version $version_number -- $version_date',
                style: new TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),

              Spacer(),

              Text(
                'Created by Ermiry',
                style: new TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5)
            ],
          )
        )
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new LoginHeader (),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                    new Form(
                      key: this._formKey,
                      child: new Column(
                        children: <Widget>[
                          // email input
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: new TextFormField(
                              enabled: this._signinLoading ? false : true,
                              autofocus: false,
                              style: new TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black38,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) return 'Email field is required!';
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(
                                  this._passwordFocusNode
                                );
                              },
                              onSaved: (value) {
                                this._authData['email'] = value;
                              },
                            ),
                          ),

                          // password input
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: new TextFormField(
                              enabled: this._signinLoading ? false : true,
                              autofocus: false,
                              focusNode: this._passwordFocusNode,
                              style: new TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black38,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) return 'Password field is required!';
                                else if (value.length < 5) return 'Password is too short!';
                                else if (value.length > 64) return 'Password is too long!';
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              onSaved: (value) {
                                this._authData['password'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 44.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2,
                              color: mainDarkBlue
                            ),
                          ),
                        ),

                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                          child: CircleAvatar(
                            backgroundColor: mainBlue,
                            radius: 32,
                            child: this._signinLoading ? 
                              new CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                              ) :
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.arrow_forward,),
                                onPressed: () => this._signinLoading ? null : this._login(),
                                iconSize: 24
                              )
                          ),
                        ),
                      ],
                    ),

                    // Spacer(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RawMaterialButton(
                            onPressed: () => Navigator.of(context).pushNamed('/register'),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                wordSpacing: 2,
                                decoration: TextDecoration.underline,
                                fontSize: 26,
                                color: mainBlue
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Forgot Password',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              wordSpacing: 2,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.04)
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.85,
            child: Container(
              child: IconButton(
                color: mainDarkBlue,
                icon: Icon(Icons.info),
                onPressed: () => this._info(),
                iconSize: 36
              )
            ),
          )
        ],
      )
    );
  }

}

class LoginHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4
          ),
          painter: new LoginPainter (),
        ),

        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.16,
            left: MediaQuery.of(context).size.width * 0.03,
          ),
          child: Text(
            'Tiny\nThings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.w700,
              // fontFamily: 'LobsterTwo',
            ),
          ),
        ),
      ],
    );
  }
}

class LoginPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(size.width * 0.4, 0);
    path.quadraticBezierTo(size.width * 0.20, size.height * 1.8, size.width * 1.44, size.height );
    path.lineTo(size.width, 0);
    path.close();

    paint.color = mainDarkBlue;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.90);
    path.quadraticBezierTo(size.width *0.6, size.height * 1.34, size.width * 0.58, size.height * 0.74);
    path.quadraticBezierTo(size.width * 0.58, size.height * 0.4, size.width * 0.8, size.height * 0.3);
    path.quadraticBezierTo(size.width, size.height * 0.23, size.width,size.height * 0.14);
    path.lineTo(size.width,0);
    path.close();

    paint.color = mainBlue;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.54);
    path.quadraticBezierTo(size.width *0.14, size.height * 0.54, size.width * 0.18, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.23, size.height * 0.24, size.width * 0.4, size.height * 0.19);
    path.quadraticBezierTo(size.width * 0.64, size.height * 0.11, size.width * 0.64,0);
    path.lineTo(size.width,0);
    path.close();

    paint.color = mainDarkBlue;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}