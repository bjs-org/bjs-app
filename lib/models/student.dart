class Student {
  String firstName;
  String lastName;
  bool female;
  DateTime birthDay;

  Student(this.firstName, this.lastName, this.female, this.birthDay);

  int compareTo(Student b) {
    var lastNameCompared = lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
    if (lastNameCompared == 0) {
      return firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
    }
    return lastNameCompared;
  }
}

List<Student> students = [
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
  Student("Liam","Heß",false,DateTime.utc(2002)),
];