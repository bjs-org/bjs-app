import 'package:bjs/models/schoolClass.dart';
import 'package:bjs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        onTap: () {
          BlocProvider.of<StudentsBloc>(context)
              .add(FetchStudentsForClass(schoolClass: schoolClass));
        },
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
