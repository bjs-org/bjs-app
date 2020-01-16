class SchoolClass {
  final String name;
  final String grade;
  final String teacherName;

  const SchoolClass({this.name, this.grade, this.teacherName});

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SchoolClass(
      name: json["className"],
      grade: json["grade"],
      teacherName: json["classTeacherName"]
    );
  }
}

final schoolClasses = [
  SchoolClass(name: "A",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "B",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "C",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
  SchoolClass(name: "D",grade: "7",teacherName: "Gutsche"),
];
