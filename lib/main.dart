import 'package:bjs/repositories/repositories.dart';
import 'package:bjs/screens/login_screen.dart';
import 'package:bjs/screens/students_screen.dart';
import 'package:bjs/screens/classes_screen.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await initializeDateFormatting("de_DE", null);

  runApp(
    App(),
  );
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AuthNotifier authNotifier;
  BjsApiClient apiClient;

  Future<bool> _loggedIn;

  @override
  void initState() {
    super.initState();
    final client = http.Client();

    authNotifier = AuthNotifier(
      basicClient: client,
    );
    _loggedIn = authNotifier.loginFromSharePrefs();

    apiClient = BjsApiClient(
      basicClient: client,
      authNotifier: authNotifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Bundesjugensspiel App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.indigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              textTheme: ButtonTextTheme.primary),
        ),
        home: FutureBuilder<bool>(
          future: _loggedIn,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Scaffold(
                  body: Center(
                    child: const CircularProgressIndicator(),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error"),
                    ),
                  );
                } else {
                  return snapshot.data ? ClassesScreen() : LoginScreen();
                }
            }
          },
        ),
        routes: {
          StudentsScreen.routeName: (_) => StudentsScreen(),
          ClassesScreen.routeName: (_) => ClassesScreen(),
          LoginScreen.routeName: (_) => LoginScreen()
        },
      ),
      providers: [
        Provider<BjsApiClient>.value(
          value: apiClient,
        ),
        ChangeNotifierProvider<AuthNotifier>.value(
          value: authNotifier,
        ),
      ],
    );
  }
}
