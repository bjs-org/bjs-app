import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class FetchStudentsForClass extends StudentEvent {
  final SchoolClass schoolClass;

  const FetchStudentsForClass({@required this.schoolClass}) : assert(schoolClass != null);

  @override
  List<Object> get props => [schoolClass];
}

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];
}

class StudentsEmpty extends StudentState {}

class StudentsLoading extends StudentState {}

class StudentsLoaded extends StudentState {
  final List<Student> students;

  StudentsLoaded({@required this.students}) : assert(students != null);

  @override
  List<Object> get props => [students];
}

class StudentsError extends StudentState {}

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final BjsApiClient apiClient;

  StudentBloc({@required this.apiClient});

  @override
  StudentState get initialState => StudentsEmpty();

  @override
  Stream<StudentState> mapEventToState(StudentEvent event) async* {
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
