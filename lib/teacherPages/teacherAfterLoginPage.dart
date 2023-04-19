import 'package:flutter/material.dart';
import 'package:timetabler/registration/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/teacherPages/TeacherSchedule.dart';

import '../MaxSat/SchedulePage.dart';


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

  const TeacherDataView({
    required this.username,
    required this.id,
    required this.email,
  });

  @override
Widget build(BuildContext context) {
  return Container(
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
        const Text(
          'ID',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          id,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          'Email',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          email,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
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
              MaterialPageRoute(builder: (context) => TeacherSchedule()),
            );
          },
          child: const Text(
            'Update Available Hours',
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
            String userName = await getCurrentUserID();
            print(userName);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListView.builder(
                  itemCount: getschedule(userName).length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          'Teacher: ${getschedule(userName)[index].teacher.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Subject: ${getschedule(userName)[index].subject}\nClassroom: ${getschedule(userName)[index].classroom.name}\nDay: ${getschedule(userName)[index].day}\nHour: ${getschedule(userName)[index].hour}:00 to ${getschedule(userName)[index].hour+1}:00',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          child: const Text(
            'View Schedule',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    )
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
