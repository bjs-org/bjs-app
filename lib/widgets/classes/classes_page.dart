import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async => await _updateClasses(context),
        child: CustomScrollView(
          slivers: [
            ClassesSliverAppBar(),
            Consumer<ClassesNotifier>(
              builder: (_, value, child) {
                if (value.isLoading) {
                  return convertToSliver(
                      Center(child: CircularProgressIndicator()));
                } else {
                  return ClassesSliverList(value.classes.toList());
                }
              },
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
      actions: <Widget>[
        IconButton(
          onPressed: () => _newClass(context),
          icon: Icon(Icons.add),
        )
      ],
    );
  }

  void _newClass(BuildContext context) {
    Provider.of<ClassFormNotifier>(context, listen: false).newClass();
    Navigator.of(context).pushNamed("/create_class");
  }
}
