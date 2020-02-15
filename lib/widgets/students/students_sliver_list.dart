import 'package:bjs/models/models.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StudentsSliverList extends StatelessWidget {
  final List<Student> students;

  StudentsSliverList(this.students) {
    students.sort((a, b) => a.compareTo(b));
  }

  Widget _buildStudent(Student student, BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(
            student.combinedName,
            style: TextStyle(fontSize: 24.0),
          ),
          leading: CircleAvatar(
            backgroundColor: student.female ? Colors.purple : Colors.indigo,
          ),
          onTap: () => _openStudent(context, student)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(
            students.map((student) => _buildStudent(student, context)).toList()));
  }

  void _openStudent(context, student) {
    Provider.of<HomepageNotifier>(context, listen: false).page = SelectedPage.SportResultsPage;
  }
}
