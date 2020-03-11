import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/repositories.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassForm extends StatefulWidget {
  static const routeName = "/classForm";

  @override
  _ClassFormState createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SchoolClass _currentClass;
  bool _isNew = false;
  BjsApiClient client;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context).settings.arguments;
    _currentClass = args ?? SchoolClass();
    _isNew = args == null;
    client = Provider.of<BjsApiClient>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(null),
          icon: Icon(Icons.arrow_back),
        ),
        title:
            Text(_isNew ? "Klasse bearbeiten" : "Neue Klasse erstellen"),
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Center(
          child: Form(
            key: _formKey,
            child: ChangeNotifierProvider<ClassFormNotifier>(
              create: (_) => ClassFormNotifier(client),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                children: [
                  TextFormField(
                    key: Key("gradeFormField"),
                    initialValue: _currentClass?.grade ?? '',
                    decoration: const InputDecoration(
                        labelText: "Stufe",
                        hintText: "bspw. 7",
                        icon: Icon(Icons.arrow_upward)),
                    onSaved: (value) => _currentClass.grade = value,
                  ),
                  TextFormField(
                    key: Key("classFormField"),
                    initialValue: _currentClass?.name ?? '',
                    decoration: const InputDecoration(
                        labelText: "Klasse",
                        hintText: "bspw. A",
                        icon: Icon(Icons.text_fields)),
                    onSaved: (value) => _currentClass.name = value,
                  ),
                  TextFormField(
                    key: Key("teacherFormField"),
                    initialValue: _currentClass?.teacherName ?? '',
                    decoration: const InputDecoration(
                        labelText: "Klassenlehrer", icon: Icon(Icons.person)),
                    onSaved: (value) => _currentClass.teacherName = value,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () async => await _onPressed(context),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    var formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();
      if (_isNew) {
        await client.postSchoolClass(_currentClass);
      } else {
        await client.patchSchoolClass(_currentClass);
      }

      Navigator.of(context).pop(_currentClass);
    }
  }
}
