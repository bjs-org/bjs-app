import 'package:bjs/models/json_parsing.dart';

class Student {
  String firstName;
  String lastName;
  bool female;
  DateTime birthDay;
  String url;
  String classUrl;

  Student({this.firstName, this.lastName, this.female, this.birthDay, this.url});

  get combinedName => "$lastName $firstName";

  int compareTo(Student b) {
    var genderCompared = _convertToInt(female).compareTo(_convertToInt(b.female));

    if (genderCompared == 0) {
      var lastNameCompared = lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
      if (lastNameCompared == 0) {
        return firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
      } else {
        return lastNameCompared;
      }
    } else {
      return genderCompared;
    }
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return Student(
        firstName: json["firstName"],
        lastName: json["lastName"],
        female: json["female"] as bool,
        birthDay: DateTime.parse(json["birthDay"]),
        url: parseLink(json["_links"]["self"]),
    );
  }

  Map<String, dynamic> toJson() => {
        if (firstName != null) "firstName": firstName,
        if (lastName != null) "lastName": lastName,
        if (female != null) "female": female,
        if (birthDay != null) "birthDay": birthDay.toIso8601String(),
        if (classUrl != null) "schoolClass": classUrl,
      };
}

int _convertToInt(female) => female ? 0 : 1;
