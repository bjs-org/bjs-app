import 'package:bjs/models/school_class.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesSliverList extends StatelessWidget {
  final List<SchoolClass> classes;

  ClassesSliverList(this.classes) {
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
        onTap: () => _openClass(context, schoolClass),
      ),
    );
  }

  void _openClass(BuildContext context, SchoolClass schoolClass) {
    Provider.of<StudentsNotifier>(context, listen: false).currentlyShownClass = schoolClass;
    Provider.of<HomepageNotifier>(context,listen: false).page = SelectedPage.StudentsPage;
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(classes
            .map((schoolClass) => _buildSchoolClass(schoolClass, context))
            .toList()));
  }
}
