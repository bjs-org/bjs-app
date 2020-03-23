import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/screens/classes_screen.dart';
import 'package:bjs/states/auth_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _defaultBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10.0));
  final _urlFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  bool _urlIsChecked = false;
  bool _isInvalidAsyncUrl = false;
  bool _isInAsyncCall = false;

  String _url;
  String _username;
  String _password;

  FocusNode _usernameFocusNode;


  @override
  void initState() {
    _usernameFocusNode = new FocusNode();
    super.initState();
  }


  @override
  void dispose() {
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var authNotifier = Provider.of<AuthNotifier>(context);

    _urlFieldKey.currentState?.validate();

    var _sendFocusNode = FocusNode();
    var _passwordFocusNode = FocusNode();

    final children = [
      TextFormField(
        key: _urlFieldKey,
        decoration: InputDecoration(
          border: _defaultBorder,
          labelText: "Server URL",
          prefixText: "http://",
          suffixText: "/api/v1",
        ),
        initialValue: authNotifier.url ?? "",
        onSaved: (value) => _url = value,
        onFieldSubmitted: (value) async => _validateUrl(context),
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.url,
      ),
      if (!_urlIsChecked)
        Text("Diese URL wurde dir vermutlich von einem Lehrer mitgeteilt"),
      if (_urlIsChecked)
        TextFormField(
          focusNode: _usernameFocusNode,
          decoration: InputDecoration(
            border: _defaultBorder,
            labelText: "Benutzername",
          ),
          onSaved: (value) => _username = value,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _usernameFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),
      if (_urlIsChecked)
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            border: _defaultBorder,
            labelText: "Password",
          ),
          focusNode: _passwordFocusNode,
          onSaved: (value) => _password = value,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _passwordFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_sendFocusNode);
          },
        ),
      if (_urlIsChecked)
        RaisedButton.icon(
          focusNode: _sendFocusNode,
          onPressed: () => _validateInformation(context),
          icon: Icon(Icons.send),
          label: Text("Einloggen"),
        ),
      if (_isInAsyncCall) Center(child: CircularProgressIndicator()),
    ];

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(36.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children
                  .map(
                    (e) => Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validateUrl(context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    _urlFieldKey.currentState.save();

    setState(() {
      _isInAsyncCall = true;
    });

    var client = Provider.of<BjsApiClient>(context, listen: false);
    var isValidUrl = await client.checkUrl(_url);

    setState(() {
      _urlIsChecked = isValidUrl;
      _isInAsyncCall = false;
    });

    if (isValidUrl) {
      _usernameFocusNode.requestFocus();
    }
  }

  Future<void> _validateInformation(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isInAsyncCall = true;
      });

      var client = Provider.of<BjsApiClient>(context, listen: false);

      var auth = Provider.of<AuthNotifier>(context, listen: false);
      var informationAreValid = await auth.login(_url, _username, _password);

      setState(() {
        _isInAsyncCall = false;
      });
      
      if (informationAreValid) {
        await Navigator.of(context).pushReplacementNamed(ClassesScreen.routeName);
      }

    }
  }
}
