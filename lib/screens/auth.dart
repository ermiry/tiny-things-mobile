import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:things/providers/auth.dart';

import 'package:things/models/http_exception.dart';

import 'package:things/animations/fade.dart';
import 'package:things/widgets/bottom.dart';
import 'package:things/style/colors.dart';

class AuthScreen extends StatefulWidget {

  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState ();

}

class _AuthScreenState extends State <AuthScreen> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  Map <String, String> _authData = {
    // 'username': '',
    'email': '',
    'password': '',
  };

  final FocusNode _passwordFocusNode = new FocusNode ();

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
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('An error ocurred!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <void> _submitLogin() async {

    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      try {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    var maxHeight = MediaQuery.of(context).size.height;
    // print(maxHeight);

    return new Scaffold(
      backgroundColor: mainBlue,
      body: new Container(
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*** title ***/
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                      FadeAnimation(1, -30, 0, Text(
                        "Login", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 64, 
                          fontWeight: FontWeight.bold
                        )
                      )),

                      SizedBox(height: 10,),

                      FadeAnimation(1.3, -30, 0, Text(
                        "Welcome Back!", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 24
                        )
                      )),
                    ],
                  ),
                ),
              ),

              new Flexible(
                // flex:,
                fit: FlexFit.loose,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.65),
                  child: new Container(
                    // height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      // child: SingleChildScrollView (
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: maxHeight >= 900 ? 60 : 20),

                            FadeAnimation(1.4, -30, 0, Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                  color: const Color.fromRGBO(25, 42, 86, 0.5),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                                )]
                              ),
                              child: new Form(
                                key: this._formKey,
                                child: new Column(
                                  children: <Widget>[
                                    // email input
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                          color: Colors.grey[200]
                                        ))
                                      ),

                                      child: new TextFormField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          hintStyle: const TextStyle(color: Colors.grey)
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
                                      padding: EdgeInsets.all(10),
                                      child: new TextFormField(
                                        focusNode: this._passwordFocusNode,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: const TextStyle(color: Colors.grey)
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
                                    )
                                  ],
                                ),
                              )
                            )),

                            SizedBox(height: maxHeight >= 900 ? 30 : 15),

                            FadeAnimation(1.5, -30, 0, new _ForgotPassword()),

                            SizedBox(height: maxHeight >= 900 ? 30 : 15),

                            FadeAnimation(1.6, -30, 0, new Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                // color: mainDarkBlue
                                color: mainBlue
                              ),
                              child: Center(
                                child: RawMaterialButton(
                                  // enableFeedback: false,
                                  // splashColor: Color.fromARGB(0, 0, 0, 0),
                                  onPressed: () {
                                    this._submitLogin();
                                  },
                                  elevation: 0,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    // fontSize: 18,
                                    fontWeight: FontWeight.w800
                                  ),
                                  child: Text("Login!"),
                                ),
                              ),
                            )),

                            SizedBox(height: maxHeight >= 900 ? 30 : 15),

                            FadeAnimation(1.8, -30, 0, Text("or", style: TextStyle(color: Colors.grey),)),

                            SizedBox(height: maxHeight >= 900 ? 30 : 15),

                            FadeAnimation(2.0, -30, 0, new _CreateAccount()),
                          ],
                        ),
                      // ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

}

class _CreateAccount extends StatefulWidget {

  @override
  _CreateAccountState createState() => new _CreateAccountState ();

}

class _CreateAccountState extends State <_CreateAccount> {

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
    // 13/02/2020 -- caused error when closing modal bottom sheet
    // _usernameFocusNode.dispose();
    // _emailFocusNode.dispose();
    // _passwordFocusNode.dispose();
    // _confirmFocusNode.dispose();

    // this._nameController.dispose();
    // this._usernameController.dispose();
    // this._emailController.dispose();
    // this._passwordController.dispose();
    // this._confirmController.dispose();

    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('An error ocurred!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('Success!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
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
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['name'],
          _authData['username'],
          _authData['email'],
          _authData['password'],
          _authData['password2']
        );
        fail = false;
      } on HttpException catch (error) {
        var jsonError = json.decode(error.toString());

        String actualError;
        if (jsonError['email'] != null) actualError = jsonError['email'];
        else if (jsonError['username'] != null) actualError = jsonError['username'];
        else if (jsonError['password'] != null) actualError = jsonError['password'];

        // print(actualError);

        _showErrorDialog(actualError);
        fail = true;
      }

      catch (error) {
        _showErrorDialog('Failed to create new account!');
        fail = true;
      }

      if (!fail) {
        _showSuccessDialog("Created new account! Now login.");

        // clear input texts
        this._nameController.clear();
        this._usernameController.clear();
        this._emailController.clear();
        this._passwordController.clear();
        this._confirmController.clear();
      }
      
    }
  }

  _showModalBottomSheet(context) {
    final height = MediaQuery.of(context).size.height;

    showModalBottomSheetApp(
      resizeToAvoidBottomPadding: true,
      // dismissOnTap: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),

          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              
              Text(
                "Create your free account!", 
                style: TextStyle(
                  color: mainBlue, 
                  fontWeight: FontWeight.bold, fontSize: 20
                )
              ),
              
              SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView (
                  child: Column (
                    children: <Widget>[
                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: new Form(
                          key: this._formKey,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromRGBO(25, 42, 86, 0.5),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ]
                            ),
                            child: Column(
                              children: <Widget>[
                                // name input
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: new BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                    ))
                                  ),
                                  child: new TextFormField(
                                    controller: this._nameController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Name",
                                      hintStyle: const TextStyle(color: Colors.grey)
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: new BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                    ))
                                  ),
                                  child: new TextFormField(
                                    controller: this._usernameController,
                                    focusNode: this._usernameFocusNode,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle: const TextStyle(color: Colors.grey)
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: new BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                    ))
                                  ),
                                  child: new TextFormField(
                                    controller: this._emailController,
                                    focusNode: this._emailFocusNode,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: const TextStyle(color: Colors.grey)
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty) return 'Email field is required!';
                                      else if (!value.contains('@')) return 'Invalid email!';
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(
                                        this._passwordFocusNode
                                      );
                                    },
                                    onSaved: (value) {
                                      _authData['email'] = value;
                                    },
                                  ),
                                ),

                                // password input
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                    ))
                                  ),
                                  child: new TextFormField(
                                    controller: this._passwordController,
                                    focusNode: this._passwordFocusNode,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: const TextStyle(color: Colors.grey)
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

                                // confirm password input
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  // decoration: BoxDecoration(
                                  //   border: Border(bottom: BorderSide(
                                  //     color: Colors.grey[200]
                                  //   ))
                                  // ),
                                  child: new TextFormField(
                                    controller: this._confirmController,
                                    focusNode: this._confirmFocusNode,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password",
                                      hintStyle: const TextStyle(color: Colors.grey)
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
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // signup button
                      new Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: mainBlue
                        ),
                        child: Center(
                          child: RawMaterialButton(
                            // enableFeedback: false,
                            // splashColor: Color.fromARGB(0, 0, 0, 0),
                            onPressed: () {
                              this._submitRegister();
                            },
                            elevation: 0,
                            textStyle: TextStyle(
                              color: Colors.white,
                              // fontSize: 18,
                              fontWeight: FontWeight.w800
                            ),
                            child: Text("Signup!"),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        // color: mainBlue
        color: mainDarkBlue
      ),
      child: Center(
        child: RawMaterialButton(
          onPressed: () {
            _showModalBottomSheet(context);
          },
          elevation: 0,
          textStyle: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.w800
          ),
          child: Text("Create Account"),
        ),
      ),
    );
  }

}

class _ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState ();

}

class _ForgotPasswordState extends State <_ForgotPassword> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  Map <String, String> _authData = {
    'email': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('An error ocurred!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('Success!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <void> _submitRecover() async {
    bool fail = false;
    
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      try {
        await Provider.of<Auth>(context, listen: false).recover(this._authData['email']);
      }

      catch (error) {
        _showErrorDialog('Failed to manage account recovery!');
        fail = true;
      }

      if (!fail) _showSuccessDialog('Check your mailbox for recovery instructions');
    }
  }

  _showModalBottomSheet(context) {
    var maxHeight = MediaQuery.of(context).size.height;

    showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: maxHeight * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: new Container (
            child: Column (
              children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Enter the email address associated with your account", 
                    style: TextStyle(
                      color: mainBlue, 
                      fontWeight: FontWeight.bold, fontSize: 20
                    )
                  ),
                ),

                SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(25, 42, 86, 0.5),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        new Form(
                          key: this._formKey,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: new TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: const TextStyle(color: Colors.grey)
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) return 'Email field is required!';
                                else if (!value.contains('@')) return 'Invalid email!';
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                // nothing here
                              },
                              onSaved: (value) {
                                this._authData['email'] = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: maxHeight >= 900 ? 60 : 30),

                // recover button
                new Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: mainBlue
                  ),
                  child: Center(
                    child: RawMaterialButton(
                      // enableFeedback: false,
                      // splashColor: Color.fromARGB(0, 0, 0, 0),
                      onPressed: () {
                        this._submitRecover();
                      },
                      elevation: 0,
                      textStyle: TextStyle(
                        color: Colors.white,
                        // fontSize: 18,
                        fontWeight: FontWeight.w800
                      ),
                      child: Text("Recover account!"),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RawMaterialButton(
        onPressed: () {
          _showModalBottomSheet(context);
        },
        elevation: 0,
        textStyle: TextStyle(
          color: Color.fromRGBO(25, 42, 86, 0.6),
          fontSize: 16
        ),
        child: Text(
          "Forgot Password?"
        )
      ),
    );
  }

}