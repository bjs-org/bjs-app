import 'package:bjs/models/models.dart';
import 'package:bjs/screens/class_screen.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesPage extends StatelessWidget {
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
        ));
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
        onTap: () async {
          await Navigator.of(context)
              .pushNamed(ClassScreen.routeName, arguments: schoolClass);
          Provider.of<ClassesNotifier>(context, listen: false).updateClasses();
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
