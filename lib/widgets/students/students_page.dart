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

class StudentsSliverAppBar extends StatelessWidget {
  final SchoolClass schoolClass;

  StudentsSliverAppBar(this.schoolClass);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        title: Text(schoolClass?.combinedName ?? 'Alle Schüler'),
      ),
      pinned: true,
      primary: true,
      expandedHeight: 150.0,
      leading: _closeButton(context),
      actions: [
        schoolClass != null
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  Provider.of<ClassFormNotifier>(context, listen: false)
                      .editClass(schoolClass);
                  Navigator.of(context).pushNamed("/create_class");
                },
              )
            : Center(),
      ],
    );
  }

  Widget _closeButton(BuildContext context) {
    if (schoolClass != null) {
      return IconButton(
          onPressed: () => _showAllStudents(context), icon: Icon(Icons.close));
    } else {
      return Container();
    }
  }

  _showAllStudents(BuildContext context) =>
      Provider.of<StudentsNotifier>(context, listen: false).showAllStudents();
}
