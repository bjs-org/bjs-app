import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/screens/students_screen.dart';
import 'package:bjs/states/classes_notifier.dart';
import 'package:bjs/widgets/custom_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassFormModalBottomSheet extends StatefulWidget {
  final SchoolClass schoolClass;

  ClassFormModalBottomSheet({Key key, this.schoolClass}) : super(key: key);

  @override
  _ClassFormModalBottomSheetState createState() => _ClassFormModalBottomSheetState();
}

class _ClassFormModalBottomSheetState extends State<ClassFormModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: widget.schoolClass != null ? "Klasse bearbeiten" : "Klasse erstellen",
      action: widget.schoolClass != null
          ? IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () => _closeModal(context),
            )
          : null,
      children: <Widget>[
        ClassForm(previousClass: widget.schoolClass),
        if (widget.schoolClass != null) Divider(),
        if (widget.schoolClass != null)
          FractionallySizedBox(
            widthFactor: 0.95,
            child: RaisedButton.icon(
              onPressed: () async => await _showStudentsForClass(context),
              icon: Icon(Icons.remove_red_eye),
              label: Text("Schüler anzeigen"),
            ),
          )
      ],
    );
  }

  void _closeModal(BuildContext context) => Navigator.of(context).pop();

  Future<void> _showStudentsForClass(BuildContext context) async {
    await Navigator.of(context).popAndPushNamed(
      StudentsScreen.routeName,
      arguments: widget.schoolClass,
    );
  }

  Future<void> _deleteClass(context, SchoolClass schoolClass) async {
    Provider.of<BjsApiClient>(context, listen: false).deleteClass(schoolClass);
    Provider.of<ClassesNotifier>(context, listen: false).updateClasses();
    _closeModal(context);
  }
}

class ClassForm extends StatefulWidget {
  final SchoolClass previousClass;

  const ClassForm({Key key, this.previousClass}) : super(key: key);

  @override
  _ClassFormState createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();

  SchoolClass _currentClass;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.previousClass ?? SchoolClass();
    _classNameController.text = widget.previousClass?.name ?? "";
  }

  @override
  void dispose() {
    _classNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: widget.previousClass?.grade ?? "",
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
            controller: _classNameController,
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
            onChanged: (value) => _classNameController.value = TextEditingValue(
              text: value.toUpperCase(),
              selection: _classNameController.selection,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          TextFormField(
            initialValue: widget.previousClass?.teacherName ?? "",
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
