import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/screens/students_screen.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/helper.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _updateClasses(context),
      child: CustomScrollView(
        slivers: [
          ClassesSliverAppBar(),
          Consumer<ClassesNotifier>(
            builder: (_, value, child) => value.isLoading
                ? SliverPadding(
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                  )
                : ClassesSliverList(value.classes),
          ),
        ],
      ),
    );
  }

  Future<void> _updateClasses(BuildContext context) async =>
      await Provider.of<ClassesNotifier>(context, listen: false)
          .updateClasses();
}

class ClassesSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GenericSliverAppBar(
      title: "Alle Klassen",
    );
  }
}

class ClassesSliverList extends StatelessWidget {
  final List<SchoolClass> classes;

  ClassesSliverList(this.classes);

  Widget _buildSchoolClass(SchoolClass schoolClass, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          schoolClass.combinedName,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(schoolClass.teacherName ?? ""),
        onTap: () async => await _showStudents(context, schoolClass),
        onLongPress: () async =>
            await _showClassInformation(context, schoolClass),
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

  Future<void> _showStudents(context, schoolClass) async {
    await Navigator.of(context)
        .pushNamed(StudentsScreen.routeName, arguments: schoolClass);
    Provider.of<ClassesNotifier>(context, listen: false).updateClasses();
  }

  Future<void> _showClassInformation(context, schoolClass) async {
    var newClass = await showSchoolClassModal(context, schoolClass: schoolClass);
    if (newClass != null && newClass is SchoolClass) {
      await Provider.of<BjsApiClient>(context, listen: false).patchSchoolClass(newClass);
      Provider.of<ClassesNotifier>(context, listen: false).updateClasses();
    }
  }
}
