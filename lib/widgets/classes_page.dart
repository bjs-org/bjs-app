import 'dart:async';

import 'package:bjs/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Text("All Classes"),
              ),
              primary: true,
              pinned: true,
              expandedHeight: 150.0,
            ),
            BlocBuilder<ClassesBloc, ClassesState>(
              builder: (context, state) => _buildFromClassesState(state),
            ),
          ],
        ));
  }

  Widget _buildFromClassesState(ClassesState state) {
    if (state is ClassesEmpty) {
      return convertToSliver(Text("Nothing here"));
    }
    if (state is ClassesLoading) {
      return convertToSliver(Center(child: CircularProgressIndicator()));
    }
    if (state is ClassesError) {
      return convertToSliver(Center(child: Text("Something went wrong")));
    }

    if (state is ClassesLoaded) {
      _refreshCompleter?.complete();
      _refreshCompleter = Completer();
      return ClassesListView(state.classes);
    }
    return SliverToBoxAdapter(child: Center());
  }

  Future<void> _onRefresh(BuildContext context) {
    BlocProvider.of<ClassesBloc>(context).add(RefreshClasses());
    return _refreshCompleter.future;
  }
}
