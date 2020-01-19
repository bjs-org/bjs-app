class Student {
  String firstName;
  String lastName;
  bool female;
  DateTime birthDay;

  Student({this.firstName, this.lastName, this.female, this.birthDay});

  int compareTo(Student b) {
    var lastNameCompared = lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
    if (lastNameCompared == 0) {
      return firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
    }
    return lastNameCompared;
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      firstName: json["firstName"],
      lastName: json["lastName"],
      female: json["female"] as bool,
      birthDay: DateTime.parse(json["birthDay"])
    );
  }
}