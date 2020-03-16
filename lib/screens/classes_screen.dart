import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClassesPage(),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () => _addClassDialog(context),
          icon: Icon(Icons.add),
          label: Text("Hinzufügen"),
        ),
      ),
    );
  }

  Future<void> _addClassDialog(BuildContext context) async {
    var newClass = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (_) => ClassFormModalBottomSheet(),
    );

    if (newClass != null && newClass is SchoolClass) {
      await Provider.of<BjsApiClient>(context, listen: false)
          .postSchoolClass(newClass);
      Provider.of<ClassesNotifier>(context, listen: false).updateClasses();
    }
  }
}

class ClassFormModalBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (context, controller) => Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: controller,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_downward),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      "Klasse hinzufügen",
                      style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Divider(),
              ClassForm(),
            ],
          ),
        ),
      ),
    );
  }
}
