import 'package:bjs/models/models.dart';
import 'package:bjs/repositories/response_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Parses classes JSON", () {
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
    expect(parsed[0].url, "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/classes/23");
  });

  test("Parses students json", () {
    const json = """{
  "_embedded": {
    "students": [
      {
        "firstName": "Philipp",
        "lastName": "Laute",
        "birthDay": "2001-08-31",
        "female": false,
        "_links": {
          "self": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/24"
          },
          "student": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/24"
          },
          "schoolClass": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/24/schoolClass"
          }
        }
      },
      {
        "firstName": "Liam",
        "lastName": "Heß",
        "birthDay": "2001-08-15",
        "female": false,
        "_links": {
          "self": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/32"
          },
          "student": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/32"
          },
          "schoolClass": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/32/schoolClass"
          }
        }
      },
      {
        "firstName": "Lisa",
        "lastName": "Mustermann",
        "birthDay": "2002-04-13",
        "female": true,
        "_links": {
          "self": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/33"
          },
          "student": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/33"
          },
          "schoolClass": {
            "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/33/schoolClass"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "http://raspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net:8080/api/v1/students/search/findAllBySchoolClass?schoolClass=http%3A%2F%2Fraspberry-balena.gtdbqv7ic1ie9w3s.myfritz.net%3A8080%2Fapi%2Fv1%2Fclasses%2F23"
    }
  }
}""";


    List<Student> students = parseStudents(json);

    expect(students[0].firstName, "Philipp");
    expect(students[0].lastName, "Laute");
    expect(students[0].female, false);
    expect(students[0].birthDay.year, 2001);
    expect(students[0].birthDay.month, 8);
    expect(students[0].birthDay.day, 31);

    expect(students[1].lastName, "Heß");
  });
}
