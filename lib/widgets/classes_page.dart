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
        onRefresh: () async => await Provider.of<ClassesPageState>(context, listen: false).updateClasses(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Alle Klassen"),
              ),
              primary: true,
              pinned: true,
              expandedHeight: 150.0,
            ),
            Consumer<ClassesPageState>(
              builder: (_, value, child) {
                if (value.isLoading) {
                  return convertToSliver(Center(child: CircularProgressIndicator()));
                } else {
                  return ClassesListView(value.classes.toList());
                }
              },
            ),
          ],
        ));
  }

}
