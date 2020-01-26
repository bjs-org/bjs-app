import 'package:bjs/models/schoolClass.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesListView extends StatelessWidget {
  final List<SchoolClass> classes;

  ClassesListView(this.classes) {
    classes.sort((a, b) => a.compareTo(b));
  }

  Widget _buildSchoolClass(SchoolClass schoolClass, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          schoolClass.combinedName,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(schoolClass.teacherName),
        onTap: () => Provider.of<StudentsPageState>(context, listen: false).currentlyShownClasses(schoolClass)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(classes
            .map((schoolClass) => _buildSchoolClass(schoolClass, context))
            .toList()));
  }
}
