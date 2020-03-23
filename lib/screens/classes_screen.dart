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
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClassesView(),
    );
  }
}
