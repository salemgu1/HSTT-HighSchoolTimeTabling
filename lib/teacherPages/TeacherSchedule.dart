import 'package:flutter/material.dart';
import 'package:timetabler/registration/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../AdminPages/AddTeacher.dart';
import '../AdminPages/AddStudent.dart';
import '../AdminPages/AddSubject.dart';
import '../AdminPages/AddRoom.dart';
import '../AdminPages/OtherActions.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class TeacherSchedule extends StatefulWidget {
  @override
  _TeacherScheduleState createState() => _TeacherScheduleState();
}

class _TeacherScheduleState extends State<TeacherSchedule> {
  Map<String, Map<String, String>> _selectedHours = {};

  List<String> listhours = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '1:00 PM',
    '2:00 PM'
  ];
  final Map<String, List<String>> _availableHours = {
    'Sunday': [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '13:00 PM',
      '14:00 PM'
    ],
    'Monday': [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '13:00 PM',
      '14:00 PM'
    ],
    'Tuesday': [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '13:00 PM',
      '14:00 PM'
    ],
    'Wednesday': [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '13:00 PM',
      '14:00 PM'
    ],
    'Thursday': [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '13:00 PM',
      '14:00 PM'
    ],
  };

  final Map<String, Map<String, String>> _selectedAvailableHours = {
    'Monday': {'start': '', 'end': ''},
    'Tuesday': {'start': '', 'end': ''},
    'Wednesday': {'start': '', 'end': ''},
    'Thursday': {'start': '', 'end': ''},
    'Friday': {'start': '', 'end': ''},
  };

  void _toggleHour(String day, String hourType, String hour) {
    setState(() {
      if (_selectedHours.containsKey(day)) {
        _selectedHours[day]![hourType] = hour;
      } else {
        _selectedHours[day] = {hourType: hour};
      }
    });
  }

  Future<bool> hasUserLogged() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      //Invalid session. Logout
      // await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }

  Future<List<ParseObject>> getSubjects() async {
    QueryBuilder<ParseObject> querySubject =
        QueryBuilder<ParseObject>(ParseObject('Subject'));
    final ParseResponse apiResponse = await querySubject.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  final List<String> options = [];
  // final List<String> subjects = [];

  Future<List> subjectsList() async {
    final List<String> subjects = [];
    final subjectsDB = await getSubjects();

    for (int i = 0; i < subjectsDB.length; i++) {
      if (options.contains(subjectsDB[i]["title"].toString())) {
      } else {
        options.add(subjectsDB[i]["title"].toString());
      }
    }
    return subjects.toList();
  }

  Future<List<ParseObject>> getTeacher(subject, username) async {
    QueryBuilder<ParseObject> queryTeacher =
        QueryBuilder<ParseObject>(ParseObject('Teacher'))
          ..whereEqualTo('id_number', username);
    final ParseResponse apiResponse = await queryTeacher.query();

    if (apiResponse.success &&
        apiResponse.results != null &&
        apiResponse.results!.isNotEmpty) {
      final teacherObject = apiResponse.results![0];
      teacherObject.set<String>('Subject', subject);
    } else {}

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  test() async {
    QueryBuilder<ParseObject> queryTeacher =
        QueryBuilder<ParseObject>(ParseObject('Teacher'));
    final ParseResponse apiResponse = await queryTeacher.query();

    if (apiResponse.success &&
        apiResponse.results != null &&
        apiResponse.results!.isNotEmpty) {
      for (final teacherObject in apiResponse.results!) {
        final subject = teacherObject.get<String>('Subject');
        print(subject);
        if (subject == "math") {}
      }
    } else {}

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> saveTeacherHours(
      Map<String, Map<String, String>> selectedHours) async {
    final currentUser = await ParseUser.currentUser();
    if (currentUser != null) {
      QueryBuilder<ParseObject> queryTeacher =
          QueryBuilder<ParseObject>(ParseObject('Teacher'))
            ..whereEqualTo('id_number', currentUser.username);
      final ParseResponse apiResponse = await queryTeacher.query();
      Map<String, Map<String, String>> prevAvailableHours = {};

      if (apiResponse.success &&
          apiResponse.results != null &&
          apiResponse.results!.isNotEmpty) {
        final teacherObject = apiResponse.results![0];

        Map<String, List<int>> hours = {
          'Sunday': [],
          'Monday': [],
          'Tuesday': [],
          'Wednesday': [],
          'Thursday': [],
        };

        List<String> days = [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday"
        ];
        if (teacherObject.get('available_hours') != null) {
          for (var i = 0; i < days.length; i++) {
            if (teacherObject.get('available_hours')[days[i]] == null) {
              if (selectedHours[days[i]] != null) {
                prevAvailableHours[days[i]] = selectedHours[days[i]]!;
              } else {
                prevAvailableHours[days[i]] = {
                  "start": "08:00 AM",
                  "end": "14:00 AM"
                };
              }
            } else if (teacherObject.get('available_hours')[days[i]] != null &&
                selectedHours[days[i]] != null &&
                teacherObject.get('available_hours')[days[i]] !=
                    selectedHours[days[i]]) {
              prevAvailableHours[days[i]] = selectedHours[days[i]]!;
            } else if (teacherObject.get('available_hours')[days[i]]["start"] !=
                    null &&
                teacherObject.get('available_hours')[days[i]]["end"] != null) {
              Map<String, String> hoursRange = {
                "start": teacherObject.get('available_hours')[days[i]]["start"],
                "end": teacherObject.get('available_hours')[days[i]]["end"]
              };
              prevAvailableHours[days[i]] = hoursRange;
            } else if (teacherObject.get('available_hours')[days[i]]["start"] !=
                    null &&
                teacherObject.get('available_hours')[days[i]]["end"] == null &&
                prevAvailableHours[days[i]] != null) {
              print(prevAvailableHours[days[i]]);
              print("prevAvailableHours[days[i]]");
              prevAvailableHours[days[i]]!["end"] = "14:00 AM";
            } else if (teacherObject.get('available_hours')[days[i]]["end"] !=
                    null &&
                teacherObject.get('available_hours')[days[i]]["start"] ==
                    null) {
              prevAvailableHours[days[i]]!["start"] = "08:00 AM";
            }
          }
        }

        for (var i = 0; i < days.length; i++) {
          if (selectedHours[days[i]] == null) {
            continue;
          } else {
            prevAvailableHours[days[i]] = selectedHours[days[i]]!;
          }
        }
        for (var i = 0; i < days.length; i++) {
          if (selectedHours[days[i]] != null) {
            if (selectedHours[days[i]]!["start"] == null) {
              prevAvailableHours[days[i]]!["start"] = "08:00 AM";
            }
            if (selectedHours[days[i]]!["end"] == null) {
              prevAvailableHours[days[i]]!["end"] = "14:00 AM";
            }
          }
        }
        teacherObject.set<Map<String, Map<String, String>>>(
            'available_hours', prevAvailableHours);

        final updatedResponse = await teacherObject.save();
        // print(teacherObject.get('available_hours'));
        // print(teacherObject.get('available_hours')["Sunday"]["start"]);

        if (updatedResponse.success) {
          print('Teacher hours saved successfully.');
        } else {
          print(
              'Error saving teacher hours: ${updatedResponse.error!.message}');
        }
      } else {
        print('Error getting teacher object: ${apiResponse.error!.message}');
      }
    } else {
      print('There is no current user.');
    }
  }

  void _saveTeacherHours() {
    // Save selected hours to database
    // print('Selected hours: $_selectedHours');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('עדכון שעות בהן אני זמין'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Day')),
              DataColumn(label: Text('Start Time')),
              DataColumn(label: Text('End Time')),
            ],
            rows: [
              for (var day in _availableHours.keys)
                DataRow(cells: [
                  DataCell(Text(day)),
                  DataCell(DropdownButton<String>(
                    value: _selectedHours[day]?['start'] ??
                        _availableHours[day]![0],
                    onChanged: (value) => _toggleHour(day, 'start', value!),
                    items: _availableHours[day]!
                        .map<DropdownMenuItem<String>>(
                            (hour) => DropdownMenuItem<String>(
                                  value: hour,
                                  child: Text(hour),
                                ))
                        .toList(),
                  )),
                  DataCell(DropdownButton<String>(
                    value: _selectedHours[day]?['end'] ??
                        _availableHours[day]!.last,
                    onChanged: (value) => _toggleHour(day, 'end', value!),
                    items: _availableHours[day]!
                        .map<DropdownMenuItem<String>>(
                            (hour) => DropdownMenuItem<String>(
                                  value: hour,
                                  child: Text(hour),
                                ))
                        .toList(),
                  )),
                ]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          saveTeacherHours(_selectedHours);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class Message {
  static void showSuccess(
      {required BuildContext context,
      required String message,
      VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            new ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showError(
      {required BuildContext context,
      required String message,
      VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(message),
          actions: <Widget>[
            new ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
