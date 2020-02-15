import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class AppHomepage extends StatefulWidget {
  @override
  _AppHomepageState createState() => _AppHomepageState();
}

class _AppHomepageState extends State<AppHomepage> {
  PageController _pageController;
  int _selectedIndex;
  HomepageNotifier _indexNotifier = HomepageNotifier();


  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: 0, keepPage: true);
    _indexNotifier.addListener(() => _animateTo(_indexNotifier.index));
  }

  @override
  void dispose() {
    super.dispose();
    _indexNotifier.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider.value(
          value: _indexNotifier,
          child: PageView(
            children: [
              ClassesPage(),
              StudentsPage(),
              Center(),
            ],
            onPageChanged: (index) => _pageChanged(index),
            controller: _pageController,
          ),
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

  _animateTo(int index) {
    _bottomTapped(index);
    _pageChanged(index);
  }

  _bottomTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  _pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


}
