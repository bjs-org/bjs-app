import 'package:bjs/models/models.dart';
import 'package:flutter/material.dart';

class ClassForm extends StatefulWidget {

  final previousClass;
  const ClassForm({Key key, this.previousClass}) : super(key: key);

  @override
  _ClassFormState createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {

  final _formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();

  SchoolClass _currentClass;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.previousClass ?? SchoolClass();
  }

  @override
  void dispose() {
    classNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "Stufe",
              hintText: "7",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Dieses Feld darf nicht leer sein";
              } else if (value.contains(" ")) {
                return "Die Stufe darf keine Leerzeichen enthalten";
              }
              return null;
            },
            onSaved: (value) => _currentClass.grade = value,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          TextFormField(
            controller: classNameController,
            decoration: InputDecoration(
              labelText: "Klasse",
              hintText: "A",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value.contains(" ")) {
                return "Der Klassenname darf keine Leerzeichen enthalten";
              }
              return null;
            },
            onSaved: (value) => _currentClass.name = value,
            onChanged: (value) => classNameController.value = TextEditingValue(
              text: value.toUpperCase(),
              selection: classNameController.selection,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Klassenlehrer",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onSaved: (value) => _currentClass.teacherName = value,
          ),
          Divider(),
          FractionallySizedBox(
            widthFactor: 0.95,
            child: RaisedButton.icon(
              onPressed: () => _save(context),
              icon: Icon(Icons.add),
              label: Text("Speichern"),
            ),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop(_currentClass);
    }
  }
}
