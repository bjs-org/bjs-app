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
    BlocProvider.of<ClassesBloc>(context).add(FetchClasses());
    return RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: BlocBuilder<ClassesBloc, ClassesState>(
          builder: (context, state) {
            if (state is ClassesEmpty) {
              return Center(child: Text("Nothing here"));
            }
            if (state is ClassesLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ClassesLoaded) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
              return ClassesListView(state.classes);
            }
            if (state is ClassesError) {
              return Center(child: Text("Something went wrong"));
            }
            return Center();
          },
        ));
  }

  Future<void> _onRefresh(BuildContext context) {
    BlocProvider.of<ClassesBloc>(context).add(RefreshClasses());
    return _refreshCompleter.future;
  }
}