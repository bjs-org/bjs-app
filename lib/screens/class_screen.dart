import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassScreen extends StatelessWidget {
  static const routeName = "/class";

  @override
  Widget build(BuildContext context) {
    final SchoolClass schoolClass = ModalRoute.of(context).settings.arguments;
    final BjsApiClient bjsApiClient = Provider.of<BjsApiClient>(context);

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => StudentsNotifier(bjsApiClient, initialClass: schoolClass),
        child: StudentsPage(),
      ),
    );
  }
}
