import 'dart:convert';
import 'dart:io';

import 'package:bjs/models/models.dart';
import 'package:bjs/models/school_class.dart';
import 'package:bjs/states/auth_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'response_parser.dart';

String generateBasicAuthString(String username, String password) {
  var base64String = base64Encode(utf8.encode("$username:$password"));
  return "Basic $base64String";
}

class _CustomClient extends http.BaseClient {
  final http.Client _inner;
  final AuthNotifier authNotifier;

  _CustomClient(this.authNotifier, this._inner)
      : assert(authNotifier != null),
        assert(_inner != null);

  String _buildBasicAuth() {
    return generateBasicAuthString(authNotifier.username, authNotifier.password);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[HttpHeaders.authorizationHeader] = _buildBasicAuth();
    request.headers[HttpHeaders.contentTypeHeader] = "application/json";
    return _inner.send(request);
  }
}

class BjsApiClient {
  final _CustomClient _client;
  final AuthNotifier authNotifier;
  final http.Client basicClient;

  BjsApiClient({@required this.basicClient, @required this.authNotifier})
      : assert(basicClient != null),
        assert(authNotifier != null),
        _client = _CustomClient(authNotifier, basicClient);

  Future<List<SchoolClass>> fetchClasses() async {
    final locationUrl = '${authNotifier.completeUrl}/classes';
    final response = await this._client.get(locationUrl);

    if (response.statusCode != 200) {
      throw Exception("Could not fetch classes");
    }

    var classes = parseSchoolClasses(utf8.decode(response.bodyBytes));
    classes.sort((a, b) => a.compareTo(b));
    return classes;
  }

  Future<List<Student>> fetchStudentsForClass(SchoolClass schoolClass) async {
    final response = await this._client.get(schoolClass.studentsUrl);

    if (response.statusCode != 200) {
      throw Exception("Could not fetch students");
    }

    var students = parseStudents(utf8.decode(response.bodyBytes));
    students.sort((a, b) => a.compareTo(b));
    return students;
  }

  Future<List<Student>> fetchStudents() async {
    final locationUrl = "${authNotifier.completeUrl}/students";
    final response = await this._client.get(locationUrl);

    if (response.statusCode != 200) {
      throw Exception("Could not fetch students");
    }

    var students = parseStudents(utf8.decode(response.bodyBytes));
    students.sort((a, b) => a.compareTo(b));
    return students;
  }

  Future<void> postSchoolClass(SchoolClass schoolClass) async {
    final locationUrl = "${authNotifier.completeUrl}/classes";
    final String jsonString = jsonEncode(schoolClass);

    final response = await this._client.post(locationUrl, body: jsonString);

    if (response.statusCode != 201) {
      throw Exception("Could not create class");
    }
  }

  Future<void> patchSchoolClass(SchoolClass schoolClass) async {
    final String jsonString = jsonEncode(schoolClass);
    final response = await this._client.patch(schoolClass.url, body: jsonString);

    if (response.statusCode != 204) {
      throw Exception("Could not patch class");
    }
  }

  Future<void> deleteClass(SchoolClass schoolClass) async {
    final response = await this._client.delete(schoolClass.url);

    if (response.statusCode != 204) {
      throw Exception("Could not delete class");
    }
  }

  Future<void> deleteStudent(Student student) async {
    final response = await this._client.delete(student.url);

    if (response.statusCode != 204) {
      throw Exception("Could not delete student");
    }
  }

  Future<void> patchStudent(Student student) async {
    String jsonString = jsonEncode(student);
    final response = await this._client.patch(student.url, body: jsonString);

    if (response.statusCode != 204) {
      throw Exception("Could not patch student");
    }
  }

  Future<void> postStudentAtClass(SchoolClass schoolClass, Student student) async {
    student.classUrl = schoolClass.url;
    String jsonString = jsonEncode(student);
    final response = await this._client.post("${authNotifier.completeUrl}/students", body: jsonString);

    if (response.statusCode != 201) {
      throw Exception("Could not create student");
    }
  }

  Future<bool> checkUrl(String url) async {
    try {
      var response = await basicClient.get("http://$url/api/v1");
      return response.statusCode != 404;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
