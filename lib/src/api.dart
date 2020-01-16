import 'dart:convert';
import 'package:http/http.dart' as http;
import 'json_parsing.dart';
import 'schoolClass.dart';

Future<List<SchoolClass>> fetchClasses() async {
  const url =
      "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/classes";
  var client = http.Client();

  const String username = "admin";
  const String password = "admin";

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  print(basicAuth);

  try {
    final response =
        await client.get(url, headers: {'Authorization': basicAuth});
    if (response.statusCode == 200) {
      return parseSchoolClasses(response.body);
    }
  } finally {
    client.close();
  }

  return null;
}
