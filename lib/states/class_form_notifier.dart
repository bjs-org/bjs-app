import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ClassFormNotifier extends ChangeNotifier {
  final BjsApiClient _apiClient;
  ClassFormNotifier(this._apiClient);

  SchoolClass _schoolClass;
  bool _existed;

  bool get existed => _existed;

  SchoolClass get schoolClass => _schoolClass;

  Future<void> send() async {
    if (_existed) {
      await _apiClient.patchSchoolClass(schoolClass);
    } else {
      await _apiClient.postSchoolClass(schoolClass);
    }

    newClass();
    notifyListeners();
  }

  void editClass(SchoolClass schoolClass) {
    _schoolClass = schoolClass;
    _existed = true;
    notifyListeners();
  }

  void newClass() {
    _schoolClass = SchoolClass();
    _existed = false;
    notifyListeners();
  }

}