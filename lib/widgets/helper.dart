import 'package:bjs/models/models.dart';
import 'package:bjs/widgets/classes/class_form.dart';
import 'package:bjs/widgets/multiple_result_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showSchoolClassModal(context, {SchoolClass schoolClass}) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    builder: (_) => ClassFormModalBottomSheet(schoolClass: schoolClass),
  );
}

Future<dynamic> showMultipleResultInput(context, SchoolClass schoolClass) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    builder: (_) => MultipleResultBottomSheet(schoolClass: schoolClass),
  );
}
