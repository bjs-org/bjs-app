import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bjs/repositories/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier with ChangeNotifier {
  final http.Client basicClient;
  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _prefs;

  AuthNotifier({@required this.basicClient})
      : assert(basicClient != null),
        this._secureStorage = FlutterSecureStorage(),
        this._prefs = SharedPreferences.getInstance();

  String _url;
  String _username;
  String _password;
  bool _admin = false;

  bool _loggedIn = false;

  String get url => _url;

  String get completeUrl => "http://$_url/api/v1";

  String get username => _username;

  bool get admin => _admin;

  bool get loggedIn => _loggedIn;

  String get password => _password;

  void logout() {
    _username = null;
    _password = null;
    _admin = false;
    _loggedIn = false;
    _syncInStorage();
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

      await _syncInStorage();

      this._admin = data["administrator"];

      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginFromSharePrefs() async {
    final prefs = await _prefs;
    final url = prefs.get("url");
    final username = prefs.get("username");
    final password = await _secureStorage.read(key: "password");

    if (url != null && username != null && password != null) {
      return await login(url, username, password);
    }
    return false;
  }

  Future<void> _syncInStorage() async {
    final prefs = await _prefs;

    if (_username == null) {
      prefs.remove("username");
    } else {
      prefs.setString("username", _username);
    }

    if (_url == null) {
      prefs.remove("url");
    } else {
      prefs.setString("url", _url);
    }

    if (_password == null) {
      await _secureStorage.delete(key: "password");
    } else {
      await _secureStorage.write(key: "password", value: _password);
    }
  }
}
