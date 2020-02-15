import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async =>
        await Provider.of<ClassesPageState>(context, listen: false)
            .updateClasses(),
        child: CustomScrollView(
          slivers: [
            ClassesSliverAppBar(),
            Consumer<ClassesPageState>(
              builder: (_, value, child) {
                if (value.isLoading) {
                  return convertToSliver(
                      Center(child: CircularProgressIndicator()));
                } else {
                  return ClassesListView(value.classes.toList());
                }
              },
            ),
          ],
        ));
  }

}

class ClassesSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Alle Klassen"),
      ),
      primary: true,
      pinned: true,
      expandedHeight: 150.0,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<CreateClassNotifier>(context, listen: false).newClass();
            Navigator.of(context).pushNamed("/create_class");
          },
          icon: Icon(Icons.add),
        )
      ],
    );
  }

}
