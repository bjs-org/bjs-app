import 'dart:async';
import 'dart:collection';

import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/repositories.dart';
import 'package:flutter/widgets.dart';

class StudentsPageState extends ChangeNotifier {
  final BjsApiClient _apiClient;

  StudentsPageState(this._apiClient) {
    loadStudents();
  }

  SchoolClass _currentlyShownClass;
  List<Student> _students = [];
  bool _isLoading = false;

  UnmodifiableListView<Student> get students => UnmodifiableListView(_students);

  bool get isLoading => _isLoading;

  SchoolClass get currentlyShownClass => _currentlyShownClass;

  set currentlyShownClass(SchoolClass value) {
    if (identical(currentlyShownClass, value)) {
      notifyListeners();

      updateStudents();
    } else {
      _currentlyShownClass = value;
      notifyListeners();

      loadStudents();
    }

  }

  showAllStudents() {
    this.currentlyShownClass = null;
  }

  Future<void> updateStudents() async {
    if (_currentClassIsValid()) {
      _students = await _apiClient.fetchStudentsForClass(currentlyShownClass);
      notifyListeners();
    } else {
      _students = await _apiClient.fetchStudents();
      notifyListeners();
    }
  }

  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();

    await updateStudents();

    _isLoading = false;
    notifyListeners();
  }

  bool _currentClassIsValid() => currentlyShownClass != null && currentlyShownClass.url != null;
}
