import 'package:flutter/material.dart';

SliverPadding convertToSliver(Widget child) {
  return SliverPadding(
    sliver: SliverToBoxAdapter(child: child),
    padding: EdgeInsets.all(20.0),
  );
}