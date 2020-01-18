import 'package:bjs/repositories/response_parser.dart';
import 'package:bjs/models/schoolClass.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Parses JSON", () {
    const json = """{  
        "_embedded": {
          "classes": [
            {
              "grade": "7",
              "className": "A",
              "classTeacherName": "Gutsche",
              "_links": {
                "self": {
                  "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/classes/23"
                },
                "class": {
                  "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/classes/23"
                }
              }
            }
          ]
        },
        "_links": {
          "self": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/classes"
          },
          "profile": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/profile/classes"
          },
          "search": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/classes/search"
          }
        }
      }""";

    List<SchoolClass> parsed = parseSchoolClasses(json);

    expect(parsed[0].grade, "7");
    expect(parsed[0].name, "A");
    expect(parsed[0].teacherName, "Gutsche");
  });
}
