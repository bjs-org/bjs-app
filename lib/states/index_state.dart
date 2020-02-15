import 'package:flutter/widgets.dart';

enum SelectedPage {
  ClassesPage, StudentsPage, SportResultsPage
}


class IndexNotifier extends ChangeNotifier {
  SelectedPage _page = SelectedPage.ClassesPage;

  set page(SelectedPage value) {
    _page = value;
    notifyListeners();
  }

  int get index => _page.index;
}