import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/api.dart';
import 'package:flutter_app/src/json_parsing.dart';
import 'package:flutter_app/src/schoolClass.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bundesjugensspiel App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BJSInterface(),
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
    SchoolClassPage(),
    Center(),
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
                icon: Icon(Icons.class_),
                title: Text("Klassen")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.school),
                title: Text("Schüler")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.text_fields),
                title: Text("Ergebnisse")
            )
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        )
    );
  }

}

class SchoolClassPage extends StatefulWidget {
  @override
  _SchoolClassPageState createState() => _SchoolClassPageState();
}

class _SchoolClassPageState extends State<SchoolClassPage> {
  Future<List<SchoolClass>> _classes;

  @override
  void initState() {
    super.initState();
    _classes = fetchClasses();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return setState(() {
          _classes = fetchClasses();
        });
      },
      child: FutureBuilder(
        future: _classes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return SchoolClassList(classes: snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


class SchoolClassList extends StatelessWidget {
  final List<SchoolClass> classes;

  SchoolClassList({Key key, this.classes}) : super(key: key);

  Widget _buildSchoolClass(SchoolClass schoolClass) {
    return Card(
      child: ListTile(
        title: Text(
          '${schoolClass.grade}${schoolClass.name}',
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(schoolClass.teacherName),
        onTap: () {
          //TODO
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: classes
            .map((schoolClass) => _buildSchoolClass(schoolClass))
            .toList());
  }
}
