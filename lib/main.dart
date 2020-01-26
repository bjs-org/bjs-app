import 'package:bjs/repositories/repositories.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
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
        home: MultiProvider(
          child: BJSInterface(),
          providers: [
            ChangeNotifierProvider<StudentsPageState>(
                create: (_) => StudentsPageState(apiClient)),
            ChangeNotifierProvider<ClassesPageState>(
                create: (_) => ClassesPageState(apiClient))
          ],
        ));
  }
}

class BJSInterface extends StatefulWidget {
  @override
  _BJSInterfaceState createState() => _BJSInterfaceState();
}

class _BJSInterfaceState extends State<BJSInterface> {
  PageController _pageController;
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(
      initialPage: 0,
      keepPage: true
    );
    Provider.of<StudentsPageState>(context, listen: false)
        .addListener(() => _bottomTapped(1));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          children: [
            ClassesPage(),
            StudentsPage(),
            Center(),
          ],
          onPageChanged: (index) => _pageChanged(index),
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
          onTap: (index) => _bottomTapped(index),
        ));
  }

  _bottomTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    });
  }

  _pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
