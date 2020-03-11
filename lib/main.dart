import 'package:bjs/repositories/repositories.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  final BjsApiClient apiClient = BjsApiClient(client: http.Client());
  runApp(App(apiClient: apiClient));
}

class App extends StatelessWidget {
  final BjsApiClient apiClient;

  App({Key key, @required this.apiClient})
      : assert(apiClient != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
          title: 'Bundesjugensspiel App',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: AppHomepage(),
          routes: {
            ClassForm.routeName: (_) => ClassForm(),
          }),
      providers: [
        Provider<BjsApiClient>.value(
          value: apiClient,
        ),
        ChangeNotifierProvider<StudentsNotifier>(
            create: (_) => StudentsNotifier(apiClient)),
        ChangeNotifierProvider<ClassesNotifier>(
            create: (_) => ClassesNotifier(apiClient))
      ],
    );
  }
}
