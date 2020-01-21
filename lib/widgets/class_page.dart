import 'package:bjs/blocs/blocs.dart';
import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/repositories.dart';
import 'package:bjs/widgets/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  final SchoolClass schoolClass;

  ClassPage({@required this.schoolClass});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        ClassInformationSliverAppBar(
          schoolClass: schoolClass,
        ),
        BlocBuilder<StudentsBloc, StudentsState>(
          builder: (context, state) {
            if (state is StudentsLoaded) {
              return (StudentSliverList(
                students: state.students,
              ));
            }
            if (state is StudentsLoading) {
              return convertToSliver(Center(child: CircularProgressIndicator(),));
            }
            if (state is StudentsEmpty) {
              return convertToSliver(Text("Nothing here"));
            }
            if (state is StudentsError) {
              return convertToSliver(Text("Something went wrong"));
            }

            return (SliverPadding(
              padding: EdgeInsets.all(8.0),
            ));
          },
        )
      ],
    );
  }
}

class StudentSliverList extends StatelessWidget {
  final List<Student> students;

  StudentSliverList({@required this.students});

  Widget _buildStudent(Student student) {
    return Card(
      child: ListTile(
          title: Text(
            "${student.lastName} ${student.firstName}",
            style: TextStyle(fontSize: 24.0),
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

class ClassInformationSliverAppBar extends StatelessWidget {
  final SchoolClass schoolClass;

  ClassInformationSliverAppBar({@required this.schoolClass})
      : assert(schoolClass != null);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        title: Text(schoolClass.combinedName),
      ),
      pinned: true,
      primary: true,
      expandedHeight: 150.0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {},
        )
      ],
    );
  }
}
