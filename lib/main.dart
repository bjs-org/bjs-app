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
  PageController _pageController;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _setPage(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      _selectedIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StudentsBloc, StudentsState>(
            listener: (BuildContext context, state) {
          if (state is StudentsLoading) {
            setState(() {});
          }
        })
      ],
      child: Scaffold(
          body: PageView(
            children: [
              ClassesPage(),
              ClassPage(
                  schoolClass: SchoolClass(
                      name: "B", grade: "8", teacherName: "Gutsche", url: "")),
              Center(),
            ],
            controller: _pageController,
          ),
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
            onTap: (index) => _setPage(index, context),
          )),
    );
  }
}
