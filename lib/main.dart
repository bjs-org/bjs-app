import 'dart:async';
import 'package:bjs/simple_bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:bjs/repositories/repositories.dart';
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
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ClassesBloc>(
              create: (BuildContext context) {
                var bloc = ClassesBloc(apiClient: apiClient);
                bloc.add(FetchClasses());
                return bloc;
              },
            ),
            BlocProvider<StudentsBloc>(
              create: (BuildContext context) =>
                  StudentsBloc(apiClient: apiClient),
            )
          ],
          child: BJSInterface(),
        ));
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
    ClassPage(
        schoolClass: SchoolClass(
            name: "A",
            grade: "7",
            teacherName: "Gutsche",
            url:
                "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/classes/23")),
    Center(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StudentsBloc, StudentsState>(listener: (BuildContext context, state) {
          if (state is StudentsLoading) {
            setState(() {
              _selectedIndex = 1;
            });
          }
        })
      ],
      child: Scaffold(
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
          )),
    );
  }
}
