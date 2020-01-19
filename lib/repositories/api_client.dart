import 'package:bjs/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bjs/models/schoolClass.dart';
import 'response_parser.dart';

class BjsApiClient {
  static const baseUrl = "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1";
  final http.Client client;

  BjsApiClient({@required this.client}) : assert(client != null);

  Map<String, String> _headers() {
    const String username = "admin";
    const String password = "admin";

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    return {'Authorization': basicAuth};
  }


  Future<List<SchoolClass>> fetchClasses() async {
    final locationUrl = '$baseUrl/classes';
    final response = await this.client.get(locationUrl, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception("Could not fetch classes");
    }

    return parseSchoolClasses(response.body);
  }

  Future<List<Student>> fetchStudentsForClass(String classUrl) async {
    final locationUrl = "$baseUrl/students/search/findAllBySchoolClass?schoolClass=$classUrl";
    final response = await this.client.get(locationUrl, headers: _headers());

    if (response.statusCode != 200) {
      throw Exception("Coult not fetch students");
    }

    return parseStudents(response.body);
  }

}