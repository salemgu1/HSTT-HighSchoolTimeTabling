import 'package:flutter/material.dart';
import 'package:timetabler/registration/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../AdminPages/AddTeacher.dart';
import '../AdminPages/AddStudent.dart';
import '../AdminPages/AddSubject.dart';
import '../AdminPages/AddRoom.dart';
import '../AdminPages/Teachers.dart';

class OtherActions extends StatelessWidget {

  ParseUser? currentUser;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            title: Text('פעולות נוספות'),
          ),
          drawer: Drawer(
            // child: ListView(
            //   // Important: Remove any padding from the ListView.
            //   padding: EdgeInsets.zero,
            //   children: [
            //     const DrawerHeader(
            //       decoration: BoxDecoration(
            //         color: Colors.blue,
            //       ),
            //       child: Text('אפשרויות'),
            //     ),
            //     ListTile(
            //       leading: Icon(
            //         Icons.add,
            //       ),
            //       title: const Text('הוספת נושא'),
            //       onTap: () {
            //         Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Subject(),));
            //       },
            //     ),
            //     ListTile(
            //       leading: Icon(
            //         Icons.add,
            //       ),
            //       title: const Text('הוספת מורה'),
            //       onTap: () {
            //         Navigator.of(context).push(MaterialPageRoute(builder:(context)=>TeacherUser(),));
            //       },
            //     ),
            //     ListTile(
            //       leading: Icon(
            //         Icons.add,
            //       ),
            //       title: const Text('הוספת תלמיד'),
            //       onTap: () {
            //         Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Student(),));
            //       },
            //     ),
            //     ListTile(
            //       leading: Icon(
            //         Icons.add,
            //       ),
            //       title: const Text('הוספת כיתה'),
            //       onTap: () {
            //         Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Room(),));
            //       },
            //     ),
            //     ListTile(
            //       leading: Icon(
            //         Icons.logout,
            //       ),
            //       title: const Text('יציאה'),
            //       onTap: () {
            //         doUserLogout();
            //         Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Login()));
            //       },
            //     ),
            //   ],
            // ),
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