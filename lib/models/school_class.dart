import 'json_parsing.dart';

class SchoolClass {
  String name;
  String grade;
  String teacherName;
  String url;
  String studentsUrl;

  SchoolClass(
      {this.name, this.grade, this.teacherName, this.url, this.studentsUrl});

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SchoolClass(
        name: json["className"],
        grade: json["grade"],
        teacherName: json["classTeacherName"],
        url: json["_links"]["self"]["href"],
        studentsUrl: parseLink(json["_links"]["students"]));
  }

  Map<String, dynamic> toJson() => {
        if (name != null) "className": name,
        if (grade != null) "grade": grade,
        if (teacherName != null) "classTeacherName": teacherName,
      };

  String get combinedName => '$grade$name';

  int compareTo(SchoolClass b) {
    var gradeCompare = int.parse(grade).compareTo(int.parse(b.grade));
    if (gradeCompare == 0) {
      return name.toLowerCase().compareTo(b.name.toLowerCase());
    }
    return gradeCompare;
  }
}

