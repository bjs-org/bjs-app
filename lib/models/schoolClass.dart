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
        teacherName: json["classTeacherName"]);
  }

  String get combinedName => '$grade$name';

  int compareTo(SchoolClass b) {
    var gradeCompare = int.parse(grade).compareTo(int.parse(b.grade));
    if (gradeCompare == 0) {
      return name.toLowerCase().compareTo(b.name.toLowerCase());
    }
    return gradeCompare;
  }
}