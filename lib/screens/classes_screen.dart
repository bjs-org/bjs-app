import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/states/states.dart';
import 'package:bjs/widgets/helper.dart';
import 'package:bjs/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ClassesScreen extends StatefulWidget {
  static const String routeName = "/classes";

  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {

  ClassesNotifier _classesNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
          value: _classesNotifier,
          child: ClassesView()
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var client = Provider.of<BjsApiClient>(context, listen: false);
    _classesNotifier = ClassesNotifier(client);
  }
}
