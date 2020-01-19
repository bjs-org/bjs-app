import 'package:bjs/repositories/api_client.dart';
import 'package:bjs/models/schoolClass.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

abstract class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object> get props => [];
}

class FetchClasses extends ClassesEvent {}

class RefreshClasses extends ClassesEvent {}

abstract class ClassesState {
  const ClassesState();
}

class ClassesEmpty extends ClassesState {}

class ClassesLoading extends ClassesState {}

class ClassesLoaded extends ClassesState {
  final List<SchoolClass> classes;

  const ClassesLoaded({@required this.classes}) : assert(classes != null);

  @override
  List<Object> get props => [classes];
}

class ClassesError extends ClassesState {}

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  final BjsApiClient apiClient;

  ClassesBloc({@required this.apiClient}) : assert(apiClient != null);

  @override
  ClassesState get initialState => ClassesEmpty();

  @override
  Stream<ClassesState> mapEventToState(ClassesEvent event) async*{
    if (event is FetchClasses) {
      yield* _mapFetchClassesToState();
    }
    if (event is RefreshClasses) {
      yield* _mapRefreshClassesToState();
    }
  }

  Stream<ClassesState> _mapFetchClassesToState() async* {
    yield ClassesLoading();

    try{
      final List<SchoolClass> classes = await apiClient.fetchClasses();
      yield ClassesLoaded(classes: classes);
    } catch (_) {
      yield ClassesError();
    }
  }

  Stream<ClassesState> _mapRefreshClassesToState() async* {
    try{
      final List<SchoolClass> classes = await apiClient.fetchClasses();
      yield ClassesLoaded(classes: classes);
    } catch (_) {
      yield ClassesError();
    }
  }
}