import 'package:flutter/widgets.dart';

enum SelectedPage {
  ClassesPage, StudentsPage, SportResultsPage
}


class IndexNotifier extends ChangeNotifier {
  SelectedPage _index;

  SelectedPage get index => _index;

  set index(SelectedPage value) {
    _index = value;
    notifyListeners();
  }
}