import 'package:flutter/material.dart';

class GenericSliverAppBar extends StatelessWidget {

  final Widget title;
  final List<Widget> actions;
  final Widget leading;

  GenericSliverAppBar({@required this.title, this.actions, this.leading}) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        title: title,
      ),
      primary: true,
      pinned: true,
      expandedHeight: 150.0,
      leading: leading,
      actions: actions,
    );
  }
}