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

  Map <String, dynamic> _userValues;
  Map <String, dynamic> get userValues { return this._userValues; }

  bool get isAuth {
    return this.token != null;
  }

  String get token { return this._token; }

  Future <void> signup(
    String name, String username, String email, String password, String confirm
  ) async {

    password.replaceAll(new RegExp(r'\t'), '');
    var passwordBytes = utf8.encode(password);
    var passwordDigest = sha256.convert(passwordBytes);

    confirm.replaceAll(new RegExp(r'\t'), '');
    var confirmBytes = utf8.encode(confirm);
    var confirmDigest = sha256.convert(confirmBytes);

    try {
       final res = await http.post(
        serverURL + '/api/users/register', 
        body: {
          'name': name.replaceAll(new RegExp(r'\t'), ''), 
          'username': username.replaceAll(new RegExp(r'\t'), ''), 
          'email': email.replaceAll(new RegExp(r'\t'), ''), 
          'password': passwordDigest.toString(),
          'confirm': confirmDigest.toString()
        }
      );

      switch (res.statusCode) {
        case 200: {
          var actualRes = json.decode(res.body);
          print(actualRes);
          this._token = actualRes['token'];

          this._userValues = Jwt.parseJwt(token);
          // print(this.userValues);

          // when we get our token from server, save to memory
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user_token', this._token);
        } break;

        default: throw HttpException (res.body.toString()); break;
      }

      notifyListeners();
    }

    // catches responses with error status codes
    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> login(String email, String password) async {

    password.replaceAll(new RegExp(r'\t'), '');
    var passwordBytes = utf8.encode(password);
    var passwordDigest = sha256.convert(passwordBytes);

    try {
      final res = await http.post(
        serverURL + '/api/users/login', 
        body: {
          'email': email.replaceAll(new RegExp(r'\t'), ''), 
          'password': passwordDigest.toString(),
        }
      );

      print(res.body);

      switch (res.statusCode) {
        case 200: {
          var actualRes = json.decode(res.body);
          print(actualRes);

          this._token = actualRes['token'];

          this._userValues = Jwt.parseJwt(token);
          // print(this.userValues);

          // when we get our token from server, save to memory
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user_token', this._token);
        } break;

        case 400:
        case 404: {
          print(res.body);
          var actualRes = json.decode(res.body);
          print(actualRes);
          throw HttpException (actualRes['error']);
          // throw HttpException ("Failed to authenticate!");
        } break;

        default: throw HttpException ("Failed to authenticate!"); break;
      }

      notifyListeners();
    }

    catch (error) {
      print(error.toString());
      throw HttpException (error.toString());
    }

  }

  Future <bool> tryAutoLogin() async {

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_token')) {
      // print('No token!');
      return false;
    }

    // get the token
    this._token = prefs.getString('user_token');

    this._userValues = Jwt.parseJwt(token);
    notifyListeners();

    return true;    // success

  }

  Future <void> recover(String email) async {

     try {
      final res = await http.post(
        serverURL + '/api/users/forgot', 
        body: {
          'email': email.replaceAll(new RegExp(r'\t'), ''), 
        }
      );

      switch (res.statusCode) {
        case 200: break;

        default: throw HttpException (res.body.toString()); break;
      }

      notifyListeners();
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> logout() async {

    this._token = null;

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('user_token');
    prefs.clear();    // to delete all saved data

    notifyListeners();

  }

  Future <void> changeName(String name) async {

    try {
      final res = await http.post(
        serverURL + '/api/users/${this._userValues['id']}/name', 
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

      switch (res.statusCode) {
        case 200: {
          var actualRes = json.decode(res.body);
          print(actualRes);
          this._token = actualRes['token'];

          this._userValues = Jwt.parseJwt(token);
          print(this._userValues);

          // when we get our token from server, save to memory
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user_token', this._token);
        } break;

        default: throw HttpException (res.body.toString()); break;
      }

      notifyListeners();
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> changePassword(String password, String confirm) async {
    
    try {
      password.replaceAll(new RegExp(r'\t'), '');
      var passwordBytes = utf8.encode(password);
      var passwordDigest = sha256.convert(passwordBytes);

      confirm.replaceAll(new RegExp(r'\t'), '');
      var confirmBytes = utf8.encode(confirm);
      var confirmDigest = sha256.convert(confirmBytes);

      final res = await http.post(
        serverURL + '/api/users/${this._userValues['id']}/password', 
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

      switch (res.statusCode) {
        case 200: {
          var actualRes = json.decode(res.body);
          print(actualRes);
        } break;

        default: throw HttpException (res.body.toString()); break;
      }

      notifyListeners();
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

  Future <void> delete() async {

    try {
      final res = await http.delete(
        serverURL + '/api/users', 
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        }
      );

      switch (res.statusCode) {
        case 200: {
          var actualRes = json.decode(res.body);
          print(actualRes);

          // after account has been deleted, logout
          await this.logout();
        } break;

        default: throw HttpException (res.body.toString()); break;
      }
    }

    catch (error) {
      throw HttpException (error.toString());
    }

  }

}