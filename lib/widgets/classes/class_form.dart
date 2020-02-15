import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassForm extends StatefulWidget {
  @override
  _ClassFormState createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ClassFormNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(state.existed ? "Klasse bearbeiten" : "Neue Klasse erstellen"),
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              children: [
                TextFormField(
                  initialValue: state.schoolClass?.grade ?? '',
                  decoration: const InputDecoration(
                      labelText: "Stufe",
                      hintText: "bspw. 7",
                      icon: Icon(Icons.arrow_upward)),
                  onSaved: (value) => state.schoolClass.grade = value,
                ),
                TextFormField(
                  initialValue: state.schoolClass?.name ?? '',
                  decoration: const InputDecoration(
                      labelText: "Klasse",
                      hintText: "bspw. A",
                      icon: Icon(Icons.text_fields)),
                  onSaved: (value) => state.schoolClass.name = value,
                ),
                TextFormField(
                  initialValue: state.schoolClass?.teacherName ?? '',
                  decoration: const InputDecoration(
                      labelText: "Klassenlehrer", icon: Icon(Icons.person)),
                  onSaved: (value) => state.schoolClass.teacherName = value,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 27.0, horizontal: 8.0),
                  child: RaisedButton.icon(
                    icon: Icon(Icons.send),
                    onPressed: () => _onPressed(context),
                    label: Text("Speichern"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    var formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();

      var state = Provider.of<ClassFormNotifier>(context, listen: false);
      var classPageState =
          Provider.of<ClassesNotifier>(context, listen: false);

      state.send().then((_) => classPageState.updateClasses());
      Navigator.of(context).pop();
    }
  }
}
