import 'dart:convert';

import 'package:bjs/models/models.dart';
import 'package:bjs/models/school_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'response_parser.dart';

class BjsApiClient {
  static const baseUrl =
      "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net/api/v1";
  final http.Client client;

  BjsApiClient({@required this.client}) : assert(client != null);

  Map<String, String> _headers() {
    const String username = "admin";
    const String password = "admin";

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  Future<List<SchoolClass>> fetchClasses() async {
    final locationUrl = '$baseUrl/classes';
    final response = await this.client.get(locationUrl, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception("Could not fetch classes");
    }

    var classes = parseSchoolClasses(utf8.decode(response.bodyBytes));
    classes.sort((a,b) => a.compareTo(b));
    return classes;
  }

  Future<List<Student>> fetchStudentsForClass(SchoolClass schoolClass) async {
    final response =
        await this.client.get(schoolClass.studentsUrl, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception("Could not fetch students");
    }

    var students = parseStudents(utf8.decode(response.bodyBytes));
    students.sort((a,b) => a.compareTo(b));
    return students;
  }

  Future<List<Student>> fetchStudents() async {
    final locationUrl = "$baseUrl/students";
    final response = await this.client.get(locationUrl, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception("Could not fetch students");
    }

    var students = parseStudents(utf8.decode(response.bodyBytes));
    students.sort((a,b) => a.compareTo(b));
    return students;
  }

  Future<void> postSchoolClass(SchoolClass schoolClass) async {
    final locationUrl = "$baseUrl/classes";
    final String jsonString = jsonEncode(schoolClass);

    final response =
        await this.client.post(locationUrl, headers: _headers(), body: jsonString);

    if (response.statusCode != 201) {
      throw Exception("Could not create class");
    }
  }

  Future<void> patchSchoolClass(SchoolClass schoolClass) async {
    final String jsonString = jsonEncode(schoolClass);
    final response = await this.client.patch(schoolClass.url, headers: _headers(), body: jsonString);

    if (response.statusCode != 204) {
      throw Exception("Could not patch class");
    }
  }

  Future<void> deleteClass(SchoolClass schoolClass) async {
    final response = await this.client.delete(schoolClass.url, headers: _headers());

    if ( response.statusCode != 204) {
      throw Exception("Could not delete class");
    }
  }

}
