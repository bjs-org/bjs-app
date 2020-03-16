import 'package:bjs/models/models.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: CustomScrollView(
        slivers: <Widget>[
          Selector<StudentsNotifier, SchoolClass>(
            builder: (_, schoolClass, child) =>
                StudentsSliverAppBar(schoolClass: schoolClass),
            selector: (_, studentsNotifier) =>
                studentsNotifier.currentlyShownClass,
          ),
          Consumer<StudentsNotifier>(
            builder: (_, studentsNotifier, child) {
              if (studentsNotifier.isLoading) {
                return convertToSliver(Center(
                  child: CircularProgressIndicator(),
                ));
              } else {
                return (StudentsSliverList(
                  studentsNotifier.students.toList(),
                ));
              }
            },
          )
        ],
      ),
      onRefresh: () async =>
          await Provider.of<StudentsNotifier>(context, listen: false)
              .updateStudents(),
    );
  }
}

class StudentsSliverAppBar extends StatelessWidget {
  final SchoolClass schoolClass;

  const StudentsSliverAppBar({Key key, this.schoolClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return schoolClass != null
        ? GenericSliverAppBar(
            title: schoolClass?.combinedName ?? 'Alle Schüler',
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
            ),
          )
        : GenericSliverAppBar(
            title: 'Alle Schüler',
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              )
            ],
          );
  }

  _editClass(BuildContext context) async {
/*
    var _newSchoolClass = await Navigator.of(context)
        .pushNamed(ClassForm.routeName, arguments: _schoolClass);

    if (_newSchoolClass is SchoolClass) {
      setState(() {
        _schoolClass = _newSchoolClass;
      });
    }
*/
  }
}
