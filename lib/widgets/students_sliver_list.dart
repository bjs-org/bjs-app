import 'package:bjs/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StudentsSliverList extends StatelessWidget {
  final List<Student> students;

  StudentsSliverList(this.students) {
    students.sort((a, b) => a.compareTo(b));
  }

  Widget _buildStudent(Student student) {
    return Card(
      child: ListTile(
          title: Text(
            "${student.lastName} ${student.firstName}",
            style: TextStyle(fontSize: 24.0),
          ),
          leading: CircleAvatar(
            backgroundColor: student.female ? Colors.purple : Colors.indigo,
          ),
          onTap: () {
            //TODO
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(
            students.map((student) => _buildStudent(student)).toList()));
  }
}
