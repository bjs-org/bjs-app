import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

abstract class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object> get props => [];
}

class FetchStudentsForClass extends StudentsEvent {
  final SchoolClass schoolClass;

  const FetchStudentsForClass({@required this.schoolClass}) : assert(schoolClass != null);

  @override
  List<Object> get props => [schoolClass];
}

abstract class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object> get props => [];
}

class StudentsEmpty extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final List<Student> students;

  StudentsLoaded({@required this.students}) : assert(students != null);

  @override
  List<Object> get props => [students];
}

class StudentsError extends StudentsState {}

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final BjsApiClient apiClient;

  StudentsBloc({@required this.apiClient});

  @override
  StudentsState get initialState => StudentsEmpty();

  @override
  Stream<StudentsState> mapEventToState(StudentsEvent event) async* {
    if (event is FetchStudentsForClass) {
      yield StudentsLoading();

      try {
        final List<Student> students = await apiClient.fetchStudentsForClass(event.schoolClass.url);
        yield StudentsLoaded(students: students);
      } catch (_) {
        yield StudentsError();
      }
    }
  }

}
