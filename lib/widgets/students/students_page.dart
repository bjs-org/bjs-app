import 'package:bjs/models/models.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _updateStudents(context),
      child: CustomScrollView(
        slivers: <Widget>[
          Selector<StudentsNotifier, SchoolClass>(
            selector: (_, studentsNotifier) =>
                studentsNotifier.currentlyShownClass,
            builder: (_, schoolClass, child) =>
                StudentsSliverAppBar(schoolClass: schoolClass),
          ),
          Consumer<StudentsNotifier>(
            builder: (_, studentsNotifier, child) => studentsNotifier.isLoading
                ? SliverPadding(
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                  )
                : StudentsSliverList(studentsNotifier.students),
          )
        ],
      ),
    );
  }

  Future<void> _updateStudents(BuildContext context) async =>
      await Provider.of<StudentsNotifier>(context, listen: false)
          .updateStudents();
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
}

class StudentsSliverList extends StatelessWidget {
  final List<Student> students;

  StudentsSliverList(this.students);

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
        delegate: SliverChildListDelegate(students
            .map((student) => _buildStudent(student, context))
            .toList()));
  }

  void _openStudent(context, student) {
    Provider.of<HomepageNotifier>(context, listen: false).page =
        SelectedPage.SportResultsPage;
  }
}

