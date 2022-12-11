import 'package:flutter/material.dart';
import 'package:timetabler/registration/Login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../AdminPages/AddTeacher.dart';
import '../AdminPages/AddStudent.dart';
import '../AdminPages/AddSubject.dart';
import '../AdminPages/AddRoom.dart';

class AfterLogin extends StatelessWidget {

  ParseUser? currentUser;
  @override
  Widget build(BuildContext context) {
    void doUserLogout() async {
      var response = await currentUser!.logout();
      if (response.success) {
        print("ASDASDASDas");
        Message.showSuccess(
            context: context,
            message: 'User was successfully logout!',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
              );
            });
      } else {
        Message.showError(context: context, message: response.error!.message);
      }
    }
    return
      Scaffold(
          appBar: AppBar(
            title: Text('Flutter FlatButton Example'),
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
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                  ),
                  title: const Text('הוספת נושא'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Subject(),));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                  ),
                  title: const Text('הוספת מורה'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>TeacherUser(),));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                  ),
                  title: const Text('הוספת תלמיד'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Student(),));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                  ),
                  title: const Text('הוספת כיתה'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Room(),));
                  },
                ),
                ListTile(
                  leading: Icon(
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
          body: Center(child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הוספת נושא', style: TextStyle(fontSize: 20.0),),
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Subject();
                    },
                    ));},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הוספת מורה', style: TextStyle(fontSize: 20.0),),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return TeacherUser();
                    },
                    ));},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הוספת תלמיד', style: TextStyle(fontSize: 20.0),),
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Student();
                    },
                    ));},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('הוספת כיתה', style: TextStyle(fontSize: 20.0),),
                onPressed: () {               Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Room();
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