import 'dart:convert' as json;

import 'package:bjs/models/schoolClass.dart';

List<SchoolClass> parseSchoolClasses(String jsonString) {
  var root = json.jsonDecode(jsonString) as Map;
  if (root.containsKey("_embedded")) {
    var embedded = root["_embedded"] as Map;

    if (embedded.containsKey("classes")) {
      var classes = embedded["classes"] as List;

      return classes
          .map((schoolClass) => SchoolClass.fromJson(schoolClass))
          .toList();
    }
  }

  return [];
}
