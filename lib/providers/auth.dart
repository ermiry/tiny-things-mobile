import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:things/models/http_exception.dart';
import 'package:things/values.dart';

class Auth with ChangeNotifier {

  String _token;
  DateTime _expiryDate;

  Map <String, dynamic> _userValues;
  Map <String, dynamic> get userValues { return this._userValues; }

  bool get isAuth {
    return this.token != null;
  }

  // FIXME: check for date!
  String get token {
    if (this._token != null) 
      // this._expiryDate != null && this._expiryDate.isAfter(DateTime.now()))
      return this._token;

    return null;
  }

  Future <void> signup(String name, String username, String email, String password, String confirm) async {

    String url = serverURL + '/api/users/register';

    password.replaceAll(new RegExp(r'\t'), '');
    var passwordBytes = utf8.encode(password);
    var passwordDigest = sha256.convert(passwordBytes);

    confirm.replaceAll(new RegExp(r'\t'), '');
    var confirmBytes = utf8.encode(confirm);
    var confirmDigest = sha256.convert(confirmBytes);

    // print(passwordDigest);

    try {
       final res = await http.post(url, 
        body: {
          'name': name.replaceAll(new RegExp(r'\t'), ''), 
          'username': username.replaceAll(new RegExp(r'\t'), ''), 
          'email': email.replaceAll(new RegExp(r'\t'), ''), 
          'password': passwordDigest.toString(),
          'password2': confirmDigest.toString()
        }
      );

      if (res.statusCode == 400) throw HttpException (res.body.toString());

      var actualRes = json.decode(res.body);
      print(actualRes);
      this._token = actualRes['token'];
      notifyListeners();
    }

    // catches responses with error status codes
    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> login(String email, String password) async {

    String url = serverURL + '/api/users/login';

    password.replaceAll(new RegExp(r'\t'), '');
    var passwordBytes = utf8.encode(password);
    var passwordDigest = sha256.convert(passwordBytes);

    try {
      final res = await http.post(url, 
        body: {
          'email': email.replaceAll(new RegExp(r'\t'), ''), 
          'password': passwordDigest.toString(),
        }
      );

      if (res.statusCode == 400) throw HttpException (res.body.toString());

      var actualRes = json.decode(res.body);
      // print(actualRes);
      this._token = actualRes['token'];

      this._userValues = Jwt.parseJwt(token);
      // print(this.userValues);

      // when we get our token from server, save to memory
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_token', this._token);

      notifyListeners();
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

  // 12/02/2020 -- 20:57 -- load saved auth values
  Future <bool> tryAutoLogin() async {

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_token')) {
      // print('No token!');
      return false;
    }

    // get the token
    this._token = prefs.getString('user_token');

    // FIXME: get the expiry date
    // if (this._expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }

    this._userValues = Jwt.parseJwt(token);
    notifyListeners();

    return true;    // success

  }

  Future <void> recover(String email) async {

     String url = serverURL + '/api/users/forgot';

     try {
      final res = await http.post(url, 
        body: {
          'email': email.replaceAll(new RegExp(r'\t'), ''), 
        }
      );

      if (res.statusCode == 500) throw HttpException (res.body.toString());
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> logout() async {

    this._token = null;
    this._expiryDate = null;

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('user_token');
    prefs.clear();    // to delete all saved data

    notifyListeners();

  }

  Future <void> changeName(String name) async {

    String url = serverURL + '/api/users/${this._userValues['id']}/name';

    try {
      final res = await http.post(url, 
        headers: {
          // 'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        },
        body: {
          // 'name': name.replaceAll(new RegExp(r'\t'), ''), 
          'name': name
        }
      );

      if (res.statusCode == 400 || res.statusCode == 500) 
        throw HttpException (res.body.toString());

      var actualRes = json.decode(res.body);
      print(actualRes);
      this._token = actualRes['token'];

      this._userValues = Jwt.parseJwt(token);
      print(this._userValues);

      // when we get our token from server, save to memory
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_token', this._token);

      notifyListeners();
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> changePassword(String password, String confirm) async {
    
    String url = serverURL + '/api/users/${this._userValues['id']}/password';

    try {
      password.replaceAll(new RegExp(r'\t'), '');
      var passwordBytes = utf8.encode(password);
      var passwordDigest = sha256.convert(passwordBytes);

      confirm.replaceAll(new RegExp(r'\t'), '');
      var confirmBytes = utf8.encode(confirm);
      var confirmDigest = sha256.convert(confirmBytes);

      final res = await http.post(url, 
        headers: {
          // 'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        },
        body: {
          'password': passwordDigest.toString(),
          'password2': confirmDigest.toString()
        }
      );

      if (res.statusCode == 400 || res.statusCode == 500) 
        throw HttpException (res.body.toString());

      var actualRes = json.decode(res.body);
      print(actualRes);
      

      notifyListeners();
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> delete() async {

    String url = serverURL + '/api/users/';

    try {
      final res = await http.delete(url, 
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        }
      );

      if (res.statusCode == 400) throw HttpException (res.body.toString());

      var actualRes = json.decode(res.body);
      print(actualRes);

      // after account has been deleted, logout
      await this.logout();
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

}