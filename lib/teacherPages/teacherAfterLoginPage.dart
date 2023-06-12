import 'package:flutter/material.dart';
import 'package:timetabler/registration/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/teacherPages/TeacherSchedule.dart';
import 'package:timetabler/teacherPages/teacherSchedulePage.dart';

import '../AdminPages/SchedulePage.dart';
import '../MaxSat/Schedule.dart';

Future<String> getCurrentUserID() async {
  List<String> data = [];
  final currentUser = await ParseUser.currentUser();
  QueryBuilder<ParseObject> queryTeacher =
      QueryBuilder<ParseObject>(ParseObject('Teacher'))
        ..whereEqualTo('id_number', currentUser.username);
  final ParseResponse apiResponse = await queryTeacher.query();
  final teacherObject = apiResponse.results![0];
  print(teacherObject.get<String>('id_number'));
  return teacherObject.get<String>('id_number');
}

class teacherAfterLogin extends StatelessWidget {
  Future<List<String>> getTeacherData() async {
    List<String> data = [];
    final currentUser = await ParseUser.currentUser();
    if (currentUser != null) {
      QueryBuilder<ParseObject> queryTeacher =
          QueryBuilder<ParseObject>(ParseObject('Teacher'))
            ..whereEqualTo('id_number', currentUser.username);
      final ParseResponse apiResponse = await queryTeacher.query();
      final teacherObject = apiResponse.results![0];
      return [
        teacherObject.get<String>('username') ?? '',
        teacherObject.get<String>('id_number') ?? '',
        teacherObject.get<String>('email') ?? '',
      ];
    } else {
      print('There is no current user.');
    }
    return ['', '', ''];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getTeacherData(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return TeacherDataView(
            username: snapshot.data![0],
            id: snapshot.data![1],
            email: snapshot.data![2],
          );
        } else {
          // Show loading indicator while data is being fetched
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class TeacherDataView extends StatelessWidget {
  final String username;
  final String id;
  final String email;

  TeacherDataView({
    required this.username,
    required this.id,
    required this.email,
  });

  ParseUser? currentUser;

  Map<int, String> daysHash = {
    1: 'Sunday',
    2: 'Monday',
    3: 'Tuesday',
    4: 'Wednesday',
    5: 'Thursday',
  };
  @override
  Widget build(BuildContext context) {
    void doUserLogout() async {
      var response = await currentUser!.logout();
      if (response.success) {
        Message.showSuccess(
            context: context,
            message: 'User was successfully logout!',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            });
      } else {
        Message.showError(context: context, message: response.error!.message);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('פרטי המורה'),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('אפשרויות'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text('יציאה'),
                onTap: () {
                  doUserLogout();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'ID',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        id,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ListTile(
                      title: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        email,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50.0,
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherSchedule()),
                        );
                      },
                      child: const Text(
                        'עדכון שעות בהן אני זמין',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50.0,
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: () async {
                        // String userName = await getCurrentUserID();
                        //     getTeachers(userName).then((teachers) {
                        //       print(teachers);
                        //       getClassrooms(userName).then((classrooms) {
                        //         print(classrooms);
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => SchedulePage(
                        //               teachers: teachers,
                        //               classrooms: classrooms,
                        //             ),
                        //           ),
                        //         );
                        //       });
                        //     });
                        String userName = await getCurrentUserID();
                        List<Schedule> filteredSchedule =
                            await getSchedule();

                        List<String> daysOfWeek = [
                          'Sunday',
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                        ];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: const Text('מערכת שעות'),
                              ),
                              body: ListView.builder(
                                itemCount: daysOfWeek.length,
                                itemBuilder: (context, index) {
                                  final day = daysOfWeek[index];
                                  final lessonsInDay = filteredSchedule
                                      .where(
                                          (item) => daysHash[item.day] == day)
                                      .toList();

                                  return Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            day,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: lessonsInDay.length,
                                          itemBuilder: (context, index) {
                                            final item = lessonsInDay[index];

                                            return ListTile(
                                              title: Row(
                                                children: [
                                                  Icon(Icons.person),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    item.teacher.name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                          '${item.classroom.name}'),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.access_time),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                          '${item.hour}:00 - ${item.hour + 1}:00'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'מערכת שעות',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ))));
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
            ElevatedButton(
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
            ElevatedButton(
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


Future<String> getSchoolIdFromCurrentUserTeacher() async {
  final ParseUser currentUser = await ParseUser.currentUser();
  if (currentUser != null) {
    final String schoolId = currentUser.get('school_id');
    return schoolId;
  } else {
    throw Exception('No current user found.');
  }
}

Future<List<Teacher>> getTeachers(String username) async {
  String schoolId = await getSchoolIdByUsername(username);
  QueryBuilder<ParseObject> queryTeacher =
      QueryBuilder<ParseObject>(ParseObject('Teacher'));
  queryTeacher.whereEqualTo('school_id', schoolId); // Add this line to filter by school ID
  final ParseResponse apiResponse = await queryTeacher.query();
  Map<String, List<int>> hours = {
    'Sunday': [],
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
  };
  if (apiResponse.success && apiResponse.results != null) {
    List<ParseObject> teacherData = apiResponse.results as List<ParseObject>;

    List<Teacher> teachers = [];

    for (var teacher in teacherData) {
      String teacherId = teacher.get('id_number');
      List<String> teacherSubject = [];
      teacherSubject.add(teacher.get('Subject'));
      List<int> teacherAvailableHours = [8, 9, 10, 11, 13, 14];
      if (teacher.get('available_hours') == null) {
        Map<String, List<int>> hours = {
          'Sunday': teacherAvailableHours,
          'Monday': teacherAvailableHours,
          'Tuesday': teacherAvailableHours,
          'Wednesday': teacherAvailableHours,
          'Thursday': teacherAvailableHours,
        };
        teachers.add(
          Teacher(teacherId, teacherSubject, hours),
        );
      } else {
        Map<String, String> convertedMap = {};

        teacher.get('available_hours').forEach((key, value) {
          convertedMap[key] = value.toString();
        });
        teachers.add(
          Teacher(teacherId, teacherSubject, reformatHours(convertedMap)),
        );
      }
    }

    return teachers;
  } else {
    return []; // or throw an exception here if needed
  }
}


Future<String> getSchoolIdByUsername(String username) async {
  QueryBuilder<ParseObject> queryTeacher =
      QueryBuilder<ParseObject>(ParseObject('Teacher'));
  queryTeacher.whereEqualTo('id_number', username); // Add this line to filter by username

  final ParseResponse apiResponse = await queryTeacher.query();

  if (apiResponse.success && apiResponse.results != null) {
    List<ParseObject> teacherData = apiResponse.results as List<ParseObject>;

    if (teacherData.isNotEmpty) {
      // print(teacherData);
      // print(teacherData[0]["school_id"]);
      // ParseObject teacher = teacherData.first;
      String schoolId = teacherData[0]["school_id"];
      return schoolId;
    } else {
      throw Exception('Teacher not found with username: $username');
    }
  } else {
    throw Exception('Failed to retrieve teacher. API response: ${apiResponse.error}');
  }
}




Future<List<Classroom>> getClassrooms(String username) async {
  String schoolId = await getSchoolIdByUsername(username);
  QueryBuilder<ParseObject> queryRoom =
      QueryBuilder<ParseObject>(ParseObject('Room'));
  queryRoom.whereEqualTo('schoolId', schoolId); // Add this line to filter by school ID
  final ParseResponse apiResponse = await queryRoom.query();

  if (apiResponse.success && apiResponse.results != null) {
    List<ParseObject> roomData = apiResponse.results as List<ParseObject>;

    List<Classroom> rooms = [];

    for (var room in roomData) {
      String roomId = room.get('room_id');
      String sets = room.get('sets');
      rooms.add(Classroom(roomId, sets));
    }


    return rooms;
  } else {
    return []; // or throw an exception here if needed
  }
}

Future<List<Schedule>> getSchedule() async {
  // Obtain teachers array from getTeacherNamesFromDb()
  String username = await getCurrentUserID();
  List<Teacher> teachers = await getTeachers(username);
  // for (var teacher in teachers) {

  //   print("teacher data for "+teacher.name);
  //   print(teacher.availableHours);
  // }

  // Obtain classrooms array from getClassroomsFromDb()
  List<Classroom> classrooms = await getClassrooms(username);

  // Create TeacherSchedulePage object
  // TeacherSchedulePage teacherSchedulePage = TeacherSchedulePage(
  //   teachers: teachers,
  //   classrooms: classrooms,
  // );
  List<Schedule> result = buildSchedule(teachers, classrooms, students);
  List<Schedule> sch = [];
  for (Schedule s in result) {
    if (s.teacher.name == username) {
      sch.add(s);
    }
  }
  // print(sch);
  return sch;

}
