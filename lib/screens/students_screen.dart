import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/helper.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsScreen extends StatelessWidget {
  static const routeName = "/students";

  @override
  Widget build(BuildContext context) {
    final SchoolClass schoolClass = ModalRoute.of(context).settings.arguments;
    final BjsApiClient bjsApiClient = Provider.of<BjsApiClient>(context);

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => StudentsNotifier(bjsApiClient, initialClass: schoolClass),
        child: StudentsPage(),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () async => await _addMultipleResults(context, schoolClass),
          icon: Icon(Icons.table_chart),
          label: Text("Ergebnisse hinzufügen"),
        ),
      ),
    );
  }

  Future<void> _addMultipleResults(context, schoolClass) async {
    await showMultipleResultInput(context, schoolClass);
  }
}

