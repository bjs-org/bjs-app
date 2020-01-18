import 'package:bjs/models/schoolClass.dart';
import 'package:flutter/material.dart';

class ClassesListView extends StatelessWidget {
  final List<SchoolClass> classes;

  ClassesListView(this.classes) {
    classes.sort((a, b) => a.compareTo(b));
  }

  Widget _buildSchoolClass(SchoolClass schoolClass) {
    return Card(
      child: ListTile(
        title: Text(
          schoolClass.combinedName,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(schoolClass.teacherName),
        onTap: () {
          //TODO
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: classes
            .map((schoolClass) => _buildSchoolClass(schoolClass))
            .toList());
  }
}