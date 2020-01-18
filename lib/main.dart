import 'dart:async';
import 'package:bjs/simple_bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:bjs/repositories/reposiories.dart';
import 'package:bjs/models/models.dart';
import 'package:bjs/blocs/blocs.dart';
import 'package:bjs/widgets/widgets.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final BjsApiClient apiClient = BjsApiClient(client: http.Client());

  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  final BjsApiClient apiClient;

  MyApp({Key key, @required this.apiClient})
      : assert(apiClient != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bundesjugensspiel App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BlocProvider(
        create: (context) => ClassesBloc(apiClient: apiClient),
        child: BJSInterface(),
      ),
    );
  }
}

class BJSInterface extends StatefulWidget {
  @override
  _BJSInterfaceState createState() => _BJSInterfaceState();
}

class _BJSInterfaceState extends State<BJSInterface> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    ClassesPage(),
    ClassPage(),
    Center(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bundesjugenspiele"),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.class_), title: Text("Klassen")),
            BottomNavigationBarItem(
                icon: Icon(Icons.school), title: Text("Schüler")),
            BottomNavigationBarItem(
                icon: Icon(Icons.text_fields), title: Text("Ergebnisse"))
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
