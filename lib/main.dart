import 'package:bjs/repositories/repositories.dart';
import 'package:bjs/screens/login_screen.dart';
import 'package:bjs/screens/students_screen.dart';
import 'package:bjs/screens/classes_screen.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  var client = http.Client();
  final AuthNotifier authNotifier = AuthNotifier(
    basicClient: client,
  );
  final BjsApiClient apiClient = BjsApiClient(
    basicClient: client,
    authNotifier: authNotifier,
  );

  initializeDateFormatting("de_DE", null).then(
    (value) => runApp(
      App(apiClient: apiClient, authNotifier: authNotifier),
    ),
  );
}

class App extends StatelessWidget {
  final BjsApiClient apiClient;
  final AuthNotifier authNotifier;

  App({Key key, @required this.apiClient, @required this.authNotifier})
      : assert(apiClient != null),
        super(key: key);

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
        home: Consumer<AuthNotifier>(
          builder: (BuildContext context, AuthNotifier value, Widget child) {
            if (!value.loggedIn) {
              return LoginScreen();
            } else {
              return ClassesScreen();
            }
          },
        ),
        routes: {
          StudentsScreen.routeName: (_) => StudentsScreen(),
        },
      ),
      providers: [
        Provider<BjsApiClient>.value(
          value: apiClient,
        ),
        ChangeNotifierProvider<AuthNotifier>.value(
          value: authNotifier,
        ),
        ChangeNotifierProvider<StudentsNotifier>(
          create: (_) => StudentsNotifier(apiClient),
        ),
        ChangeNotifierProvider<ClassesNotifier>(
          create: (_) => ClassesNotifier(apiClient),
        )
      ],
    );
  }
}
