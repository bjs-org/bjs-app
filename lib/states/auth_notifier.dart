import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bjs/repositories/api_client.dart';


class AuthNotifier with ChangeNotifier {
  final http.Client basicClient;

  AuthNotifier({@required this.basicClient});

  String _url;
  String _username;
  String _password;
  bool _admin;

  bool _loggedIn = false;

  String get completeUrl => "http://$_url/api/v1";

  String get username => _username;

  set completeUrl(String value) {
    _url = value;
    notifyListeners();
  }

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  bool get admin => _admin;

  set admin(bool value) {
    _admin = value;
    notifyListeners();
  }

  bool get loggedIn => _loggedIn;

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  void logout() {
    _url = null;
    _username = null;
    _password = null;
    _admin = null;
    _loggedIn = false;
    notifyListeners();
  }

  Future<bool> login(String url, String username, String password) async {
    try {
      var response = await basicClient.get("http://$url/api/v1/auth", headers: {
        HttpHeaders.authorizationHeader: generateBasicAuthString(username, password)
      });

      if (response.statusCode == 401 || response.statusCode == 404) {
        return false;
      }

      var data = json.decode(utf8.decode(response.bodyBytes)) as Map;

      this._password = password;
      this._username = username;
      this._url = url;
      this._loggedIn = true;

      this._admin = data["administrator"];

      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }

  }
}
