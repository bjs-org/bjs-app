import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassRoute extends StatelessWidget {
  static const routeName = "/class";

  @override
  Widget build(BuildContext context) {
    final SchoolClass schoolClass = ModalRoute.of(context).settings.arguments;
    final BjsApiClient bjsApiClient = Provider.of<BjsApiClient>(context);
    final StudentsNotifier notifier = StudentsNotifier(bjsApiClient);

    notifier.currentlyShownClass = schoolClass;

    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: notifier,
        child: StudentsPage(),
      ),
    );
  }
}
