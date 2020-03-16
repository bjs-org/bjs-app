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
  SchoolClass _currentClass;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.previousClass ?? SchoolClass();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
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
                    }
                    return null;
                  },
                  onSaved: (value) => _currentClass.grade = value,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
              ),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Klasse",
                    hintText: "A",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) => _currentClass.name = value,
                ),
              )
            ],
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
