import 'package:bjs/models/models.dart';
import 'package:bjs/states/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateClass extends StatefulWidget {
  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SchoolClass _schoolClass = SchoolClass();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CreateClassNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Neue Klasse erstellen"),
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
                    label: Text("Absenden"),
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

      var state = Provider.of<CreateClassNotifier>(context, listen: false);
      var classPageState =
          Provider.of<ClassesPageState>(context, listen: false);

      state.send().then((_) => classPageState.updateClasses());
      Navigator.of(context).pop();
    }
  }
}
