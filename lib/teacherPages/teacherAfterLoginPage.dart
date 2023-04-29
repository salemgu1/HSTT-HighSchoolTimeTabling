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

   TeacherDataView({
    required this.username,
    required this.id,
    required this.email,
  });

    ParseUser? currentUser;


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
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Login()));
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
                  MaterialPageRoute(builder: (context) => TeacherSchedule()),
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
            String userName = await getCurrentUserID();
            Navigator.push(
              context,
MaterialPageRoute(
  builder: (context) => Scaffold(
    appBar: AppBar(
      title: const Text('מערכת שעות'),
    ),
    body: ListView.builder(
      itemCount: getSchedule(userName).length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(
              'Teacher: ${getSchedule(userName)[index].teacher.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Subject: ${getSchedule(userName)[index].subject}\nClassroom: ${getSchedule(userName)[index].classroom.name}\nDay: ${getSchedule(userName)[index].day}\nHour: ${getSchedule(userName)[index].hour}:00 to ${getSchedule(userName)[index].hour+1}:00',
            ),
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
    )
  )
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
