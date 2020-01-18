import 'package:bjs/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClassInformation(
        schoolClass: SchoolClass(name: "A", grade: "7", teacherName: "Gutsche"),
      ),
      Expanded(child: StudentListView(students: students))
    ]);
  }
}

class StudentListView extends StatelessWidget {
  final List<Student> students;

  StudentListView({@required this.students});

  Widget _buildStudent(Student student) {
    return Card(
      child: ListTile(
          title: Text(
            "${student.lastName} ${student.firstName}",
            style: TextStyle(fontSize: 24.0),
          ),
          onTap: () {
            //TODO
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: students.map((student) => _buildStudent(student)).toList());
  }
}

class ClassInformation extends StatelessWidget {
  final SchoolClass schoolClass;

  ClassInformation({@required this.schoolClass}) : assert(schoolClass != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${schoolClass.combinedName} - ${schoolClass.teacherName}",
          style: TextStyle(fontSize: 36.0),
        ),
      ),
    );
  }
}
