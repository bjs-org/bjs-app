import 'package:bjs/models/models.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class StudentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: CustomScrollView(
        slivers: <Widget>[
          Selector<StudentsPageState, SchoolClass>(
            builder: (_, value, child) =>
                StudentsInformationSliverAppBar(value),
            selector: (_, value) => value.currentlyShownClass,
          ),
          Consumer<StudentsPageState>(
            builder: (_, value, child) {
              if (value.isLoading) {
                return convertToSliver(Center(
                  child: CircularProgressIndicator(),
                ));
              } else {
                return (StudentsSliverList(
                  value.students.toList(),
                ));
              }
            },
          )
        ],
      ),
      onRefresh: () async =>
          await Provider.of<StudentsPageState>(context, listen: false)
              .updateStudents(),
    );
  }
}

class StudentsInformationSliverAppBar extends StatelessWidget {
  final SchoolClass schoolClass;

  StudentsInformationSliverAppBar(this.schoolClass);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
            schoolClass != null ? schoolClass.combinedName : 'Alle Schüler'),
      ),
      pinned: true,
      primary: true,
      expandedHeight: 150.0,
      leading: _buildLeading(context),
      actions: [
        schoolClass != null
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  Provider.of<CreateClassNotifier>(context, listen: false).editClass(schoolClass);
                  Navigator.of(context).pushNamed("/create_class");
                },
              )
            : Center(),
      ],
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (schoolClass != null) {
      return IconButton(
          onPressed: () =>
              Provider.of<StudentsPageState>(context, listen: false)
                  .showAllStudents(),
          icon: Icon(Icons.close));
    } else {
      return Container();
    }
  }
}
