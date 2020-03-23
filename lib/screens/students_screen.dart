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
    final BjsApiClient bjsApiClient = Provider.of<BjsApiClient>(context, listen: false);

    SchoolClass _schoolClass = ModalRoute.of(context).settings.arguments;
    StudentsNotifier _studentsNotifier =
        StudentsNotifier(bjsApiClient, initialClass: _schoolClass);

    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: _studentsNotifier,
        child: StudentsView(),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () async => await _addMultipleResults(context, _schoolClass),
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
