import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/auth.dart';

import 'package:things/models/http_exception.dart';

import 'package:things/style/colors.dart';

class RegisterScreen extends StatefulWidget {

  static const routeName = '/register';

  @override
  State<StatefulWidget> createState() => _RegisterScreenState ();

}

class _RegisterScreenState extends State <RegisterScreen> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  final Map <String, String> _authData = {
    'name': '',
    'username': '',
    'email': '',
    'password': '',
    'password2': '',
  };

  final FocusNode _usernameFocusNode = new FocusNode ();
  final FocusNode _emailFocusNode = new FocusNode ();
  final FocusNode _passwordFocusNode = new FocusNode ();
  final FocusNode _confirmFocusNode = new FocusNode ();

  final TextEditingController _nameController = new TextEditingController ();
  final TextEditingController _usernameController = new TextEditingController ();
  final TextEditingController _emailController = new TextEditingController ();
  final TextEditingController _passwordController = new TextEditingController ();
  final TextEditingController _confirmController = new TextEditingController ();

  @override
  void dispose()  {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();

    this._nameController.dispose();
    this._usernameController.dispose();
    this._emailController.dispose();
    this._passwordController.dispose();
    this._confirmController.dispose();

    super.dispose();
  }

  bool _loading = false;

  void _showSuccessDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Success!', 
          style: const TextStyle(color: mainBlue, fontSize: 28),
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

  Future <void> _submitRegister() async {
    bool fail = false;
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      try {
        setState(() => this._loading = true);
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['name'],
          _authData['username'],
          _authData['email'],
          _authData['password'],
          _authData['password2']
        );
        fail = false;
      } on HttpException catch (error) {
        _showErrorDialog(error.toString());
        fail = true;
      }

      catch (error) {
        _showErrorDialog('Failed to create new account!');
        fail = true;
      }

      finally {
        setState(() => this._loading = false);

        if (!fail) {
          Navigator.of(context).pop();
          _showSuccessDialog("Created new account! Now login.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new RegisterHeader (),

          SingleChildScrollView(
            child: Form(
              key: this._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 48,
                      left: 4,
                    ),
                    child: IconButton(
                      onPressed: () => this._loading ? null : Navigator.of(context).pop(),
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      'Create\nAccount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // name input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: new TextFormField(
                      enabled: this._loading ? false : true,
                      autofocus: false,
                      controller: this._nameController,
                      style: new TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        )
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return 'Name field is required!';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(
                          this._usernameFocusNode
                        );
                      },
                      onSaved: (value) {
                        this._authData['name'] = value;
                      },
                    ),
                  ),

                  // username input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: new TextFormField(
                      autofocus: false,
                      enabled: this._loading ? false : true,
                      controller: this._usernameController,
                      focusNode: this._usernameFocusNode,
                      style: new TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        )
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return 'Username field is required!';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(
                          this._emailFocusNode
                        );
                      },
                      onSaved: (value) {
                        _authData['username'] = value;
                      },
                    ),
                  ),

                  // email input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: new TextFormField(
                      enabled: this._loading ? false : true,
                      autofocus: false,
                      controller: this._emailController,
                      focusNode: this._emailFocusNode,
                      style: new TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        )
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
                      enabled: this._loading ? false : true,
                      autofocus: false,
                      controller: this._passwordController,
                      focusNode: this._passwordFocusNode,
                      style: new TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        )
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return 'Password field is required!';
                        else if (value.length < 5) return 'Password is too short!';
                        else if (value.length > 64) return 'Password is too long!';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(
                          this._confirmFocusNode
                        );
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                  ),

                  // confirm input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: new TextFormField(
                      enabled: this._loading ? false : true,
                      autofocus: false,
                      controller: this._confirmController,
                      focusNode: this._confirmFocusNode,
                      style: new TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white
                          )
                        )
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return 'Confirm password field is required!';
                        if (value != this._passwordController.text) return 'Passwords do not match!';
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onSaved: (value) {
                        _authData['password2'] = value;
                      },
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 44.0),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 2,
                              color: Colors.white
                          ),
                        ),
                      ),

                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                        child: CircleAvatar(
                          backgroundColor: mainBlue,
                          radius: 40,
                          child: this._loading ? 
                            new CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                            ) :
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.arrow_forward,),
                              onPressed: this._loading ? null : () => _submitRegister(),
                              iconSize: 24
                            )
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

class RegisterHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: RegisterPainter(),
    );
  }

}

class RegisterPainter extends CustomPainter{

  Color colorTwo = Colors.grey[800];
  Color colorThree = Colors.blue[400];

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.48, size.height);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.88, size.width * 0.8, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.93, size.height * 0.76, size.width , size.height * 0.67);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = mainBlue;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.62);
    path.quadraticBezierTo(size.width *0.16, size.height * 0.48, size.width * 0.47, size.height * 0.44);
    path.quadraticBezierTo(size.width * 0.78, size.height * 0.4, size.width, size.height * 0.22);
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