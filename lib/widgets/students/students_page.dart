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
                StudentsSliverAppBar(schoolClass),
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

class StudentsSliverAppBar extends StatefulWidget {
  final SchoolClass schoolClass;

  StudentsSliverAppBar(this.schoolClass);

  @override
  _StudentsSliverAppBarState createState() =>
      _StudentsSliverAppBarState(schoolClass);
}

class _StudentsSliverAppBarState extends State<StudentsSliverAppBar> {
  SchoolClass _schoolClass;

  _StudentsSliverAppBarState(this._schoolClass);

  @override
  Widget build(BuildContext context) {
    return _schoolClass != null
        ? GenericSliverAppBar(
            title: _schoolClass?.combinedName ?? 'Alle Schüler',
            leading: IconButton(
                onPressed: () => _closeClass(context), icon: Icon(Icons.close)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editClass(context),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              )
            ],
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
    var _newSchoolClass = await Navigator.of(context)
        .pushNamed(ClassForm.routeName, arguments: _schoolClass);

    if (_newSchoolClass is SchoolClass) {
      setState(() {
        _schoolClass = _newSchoolClass;
      });
    }
  }

  _closeClass(BuildContext context) {
    Provider.of<HomepageNotifier>(context, listen: false).page =
        SelectedPage.ClassesPage;
    Provider.of<StudentsNotifier>(context, listen: false).showAllStudents();
  }
}
