import 'package:bjs/models/models.dart';
import 'package:bjs/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MultipleResultBottomSheet extends StatelessWidget {
  final SchoolClass schoolClass;

  const MultipleResultBottomSheet({Key key, this.schoolClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "Ergebnisse hinzufügen",
      children: [

      ],
    );
  }
}
