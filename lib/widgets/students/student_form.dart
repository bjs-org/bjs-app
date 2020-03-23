import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/widgets/custom_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentBottomSheet extends StatefulWidget {
  final SchoolClass schoolClass;
  final Student student;
  final Function onShouldUpdate;

  StudentBottomSheet({Key key, this.schoolClass, this.student, this.onShouldUpdate}) : super(key: key);

  @override
  _StudentBottomSheetState createState() => _StudentBottomSheetState();
}

class _StudentBottomSheetState extends State<StudentBottomSheet> {
  final OutlineInputBorder defaultInputFieldBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(10.0));

  Student _savedStudent = Student();

  final _formKey = GlobalKey<FormState>();

  _saveStudent(context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var client = Provider.of<BjsApiClient>(context, listen: false);

      bool alreadyExisted = widget.student != null;
      if (alreadyExisted) {
        _savedStudent.url = widget.student.url;
        Navigator.of(context).pop();
        await client.patchStudent(_savedStudent);
        widget.onShouldUpdate();
      } else if (widget.schoolClass != null) {
        Navigator.of(context).pop();
        await client.postStudentAtClass(widget.schoolClass, _savedStudent);
        widget.onShouldUpdate();
      }
    }
  }

  _deleteStudent(BuildContext context) async {
    var client = Provider.of<BjsApiClient>(context, listen: false);
    Navigator.of(context).pop();
    await client.deleteStudent(widget.student);
    widget.onShouldUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> formChildren = [
      TextFormField(
        initialValue: widget.student?.firstName ?? "",
        decoration: InputDecoration(
          border: defaultInputFieldBorder,
          labelText: "Vorname",
        ),
        onSaved: (value) => _savedStudent.firstName = value,
      ),
      TextFormField(
        initialValue: widget.student?.lastName ?? "",
        decoration: InputDecoration(
          border: defaultInputFieldBorder,
          labelText: "Nachname",
        ),
        onSaved: (value) => _savedStudent.lastName = value,
      ),
      CustomDatePicker(
        decoration: InputDecoration(
          border: defaultInputFieldBorder,
          labelText: "Geburtstag",
        ),
        initialDate: widget.student?.birthDay,
        onSaved: (value) => _savedStudent.birthDay = value,
      ),
      GenderSelectField(
          female: widget.student?.female,
          decoration: InputDecoration(
            border: defaultInputFieldBorder,
            labelText: "Geschlecht",
          ),
          onSaved: (value) => _savedStudent.female = value),
      Divider(),
      RaisedButton.icon(
        onPressed: () => _saveStudent(context),
        icon: Icon(Icons.save),
        label: Text("Speichern"),
      )
    ];

    return CustomBottomSheet(
      title: widget.student != null ? "Schüler bearbeiten" : "Schüler erstellen",
      action: widget.student != null
          ? IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteStudent(context))
          : null,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: formChildren
                  .map(
                    (formChild) => Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: formChild,
                    ),
                  )
                  .toList()),
        )
      ],
    );
  }
}

class GenderSelectField extends StatefulWidget {
  final InputDecoration decoration;
  final bool female;
  final FormFieldSetter<bool> onSaved;

  const GenderSelectField({Key key, this.female, this.decoration, this.onSaved})
      : super(key: key);

  @override
  _GenderSelectFieldState createState() => _GenderSelectFieldState();
}

class _GenderSelectFieldState extends State<GenderSelectField> {
  List<String> _possibleSelections;
  String _selectedValue;

  @override
  void initState() {
    _possibleSelections = <String>["Weiblich", "Männlich"];
    _selectedValue = widget.female == null || widget.female ? "Weiblich" : "Männlich";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: widget.decoration,
      value: _selectedValue,
      items: _possibleSelections
          .map<DropdownMenuItem<String>>(
            (value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
      onChanged: (String value) {
        setState(() {
          _selectedValue = value;
        });
      },
      onSaved: (value) {
        if (widget.onSaved != null) {
          return widget.onSaved(_selectedValue == "Weiblich");
        }
      },
    );
  }
}

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final InputDecoration decoration;
  final FormFieldSetter<DateTime> onSaved;

  const CustomDatePicker({Key key, this.initialDate, this.decoration, this.onSaved})
      : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  TextEditingController _birthDayController;
  InputDecoration _decoration;
  DateTime _currentDate;

  InputDecoration _copyDecoration() {
    return widget.decoration != null
        ? widget.decoration.copyWith(
            suffixIcon: Icon(
              Icons.arrow_drop_down,
            ),
          )
        : InputDecoration(
            suffixIcon: Icon(
              Icons.arrow_drop_down,
            ),
          );
  }

  @override
  void initState() {
    _currentDate =
        widget.initialDate ?? DateTime.now().subtract(Duration(days: 365 * 12));
    _birthDayController = TextEditingController(text: formatDate(_currentDate) ?? "");
    _decoration = _copyDecoration();
    super.initState();
  }

  @override
  void dispose() {
    _birthDayController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDay(BuildContext context, DateTime initialDate) async {
    DateTime now = DateTime.now();
    DateTime initial = initialDate ?? now;

    DateTime newDate = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: initial,
      firstDate: now.subtract(Duration(days: 365 * 25)),
      lastDate: now.subtract(Duration(days: 365 * 5)),
    );

    if (newDate != null && !identical(newDate, initialDate)) {
      _birthDayController.text = formatDate(newDate);
      _currentDate = newDate;
    }
  }

  String formatDate(DateTime date) => DateFormat.yMMMd("de_DE").format(date);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => await _selectBirthDay(context, _currentDate),
      child: IgnorePointer(
        child: TextFormField(
            controller: _birthDayController,
            decoration: _decoration,
            onSaved: (value) {
              if (widget.onSaved != null) {
                return widget.onSaved(_currentDate);
              }
            }),
      ),
    );
  }
}
