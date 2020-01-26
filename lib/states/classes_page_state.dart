import 'dart:collection';

import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/repositories.dart';
import 'package:flutter/foundation.dart';

class ClassesPageState extends ChangeNotifier {
  final BjsApiClient _apiClient;

  ClassesPageState(this._apiClient) {
    loadClasses();
  }

  List<SchoolClass> _classes = [];
  bool _isLoading = false;

  UnmodifiableListView<SchoolClass> get classes => UnmodifiableListView(_classes);
  bool get isLoading => _isLoading;

  Future<void> updateClasses() async {
    _classes = await _apiClient.fetchClasses();
    notifyListeners();
  }

  Future<void> loadClasses() async {
    _isLoading = true;
    notifyListeners();

    await updateClasses();

    _isLoading = false;
    notifyListeners();
  }
}