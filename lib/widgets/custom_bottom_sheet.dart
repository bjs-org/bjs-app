import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final IconButton action;

  const CustomBottomSheet({Key key, this.children, this.title, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return ListView(
          padding: EdgeInsets.all(16.0),
          controller: scrollController,
          children: <Widget>[
            _createHeader(context),
            Divider(),
            if (children != null) for (var child in children) child
          ],
        );
      },
    );
  }

  Widget _createHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () => Navigator.pop(context),
        ),
        Flexible(
          flex: 9,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
        ),
        action != null ? action : Spacer(flex: 1,),
      ],
    );
  }
}
