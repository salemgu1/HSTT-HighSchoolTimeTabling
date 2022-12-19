import 'package:flutter/material.dart';
import '../registration/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../AdminPages/AddTeacher.dart';
import '../AdminPages/AddStudent.dart';
import '../AdminPages/AddSubject.dart';
import '../AdminPages/AddRoom.dart';
import '../AdminPages/Teachers.dart';
import '../AdminPages/Students.dart';
import '../AdminPages/Rooms.dart';
import '../AdminPages/Subjects.dart';

class OtherActions extends StatelessWidget {

  ParseUser? currentUser;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            title: Text('פעולות נוספות'),
          ),
          body: Center(child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הצגת מורים', style: TextStyle(fontSize: 20.0),),
                color: Colors.red[200],
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Teachers();
                    },
                    ));},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הצגת תלמידים', style: TextStyle(fontSize: 20.0),),
                color: Colors.blue[200],
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Students();
                    },
                    ));},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הצגת חדרים', style: TextStyle(fontSize: 20.0),),
                color: Colors.blue[700],
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Rooms();
                    },
                    ));},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הצגת נושאים', style: TextStyle(fontSize: 20.0),),
                color: Colors.red[700],
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Subjects();
                    },
                    ));},
              ),
            ),
          ]
          ))

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