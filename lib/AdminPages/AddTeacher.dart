import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import '../components/key.dart';
import 'package:timetabler/AdminPages/AfterLogin.dart';


class Teacher extends ParseUser{
  Teacher(String? username, String? password, String? emailAddress,String school_id) : super(username, password, emailAddress);

}
class TeacherUser extends StatefulWidget {
  @override
  _AddTeacherUser createState() => _AddTeacherUser();
}

class _AddTeacherUser extends State<TeacherUser> {
  // late String name;

  final name = TextEditingController();
  final email = TextEditingController();
  final id_number= TextEditingController();
  final school_id= TextEditingController();


  void addUser() async {
    if (name.text.trim().isEmpty && email.text.trim().isEmpty && id_number.text.trim().isEmpty) {
      SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      );
      return;
    }

    await saveTeacher(name.text,email.text,id_number.text,school_id.text);
    showSuccess();
    Teacher teacher = new Teacher(id_number.text,id_number.text,email.text,school_id.text);
    teacher.save();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            decoration: const BoxDecoration(
              color: Color(0xffF2F2F2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: name,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'שם:'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: id_number,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'מספר מזהה:'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: email,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Email:'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: school_id,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'מספר מזהה של בית ספר:'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Colors.blueAccent,
                    ),
                    onPressed: addUser,
                    child: Text("הוספה")),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Future<void> saveTeacher(String name, String email, String id,String school_id) async {
    final teacher = ParseObject('Teacher')..set('name', name)..set('email', email)..set('id_number', id)..set('school_id', school_id);
    await teacher.save();
  }
  Future<List<ParseObject>> getTeacher() async {
    QueryBuilder<ParseObject> queryTodo =
    QueryBuilder<ParseObject>(ParseObject('Teacher'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }


  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("מורה נוסף בהצלחה "),
          actions: <Widget>[
            new FlatButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
//
//
// class Teacher extends StatefulWidget {
//
//   @override
//   _TeacherState createState() => _TeacherState();
// }
//
// class _TeacherState extends State<Teacher> {
//   final todoController = TextEditingController();
//
//   void addToDo() async {
//     if (todoController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Empty title"),
//         duration: Duration(seconds: 2),
//       ));
//       return;
//     }
//     await saveSubject(todoController.text);
//     setState(() {
//       todoController.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Container(
//               width: 400,
//               height: 400,
//               padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       autocorrect: true,
//                       textCapitalization: TextCapitalization.sentences,
//                       controller: todoController,
//                       decoration: InputDecoration(
//                           labelText: "נושא חדש",
//                           labelStyle: TextStyle(color: Colors.blueAccent)),
//                     ),
//                   ),
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         onPrimary: Colors.white,
//                         primary: Colors.blueAccent,
//                       ),
//                       onPressed: addToDo,
//                       child: Text("הוספה")),
//                 ],
//               )),
//           // Expanded(
//           //     child: FutureBuilder<List<ParseObject>>(
//           //         future: getSubject(),
//           //         builder: (context, snapshot) {
//           //           switch (snapshot.connectionState) {
//           //             case ConnectionState.none:
//           //             case ConnectionState.waiting:
//           //               return Center(
//           //                 child: Container(
//           //                     width: 100,
//           //                     height: 100,
//           //                     child: CircularProgressIndicator()),
//           //               );
//           //             default:
//           //               if (snapshot.hasError) {
//           //                 return Center(
//           //                   child: Text("Error..."),
//           //                 );
//           //               }
//           //               if (!snapshot.hasData) {
//           //                 return Center(
//           //                   child: Text("No Data..."),
//           //                 );
//           //               } else {
//           //                 return ListView.builder(
//           //                     padding: EdgeInsets.only(top: 10.0),
//           //                     itemCount: snapshot.data!.length,
//           //                     itemBuilder: (context, index) {
//           //                       //*************************************
//           //                       //Get Parse Object Values
//           //                       final varTodo = snapshot.data![index];
//           //                       final varTitle = '';
//           //                       final varDone = false;
//           //                       //*************************************
//           //
//           //                       return ListTile(
//           //                         title: Text(varTitle),
//           //                         leading: CircleAvatar(
//           //                           child: Icon(
//           //                               varDone ? Icons.check : Icons.error),
//           //                           backgroundColor:
//           //                           varDone ? Colors.green : Colors.blue,
//           //                           foregroundColor: Colors.white,
//           //                         ),
//           //                         trailing: Row(
//           //                           mainAxisSize: MainAxisSize.min,
//           //                           children: [
//           //                             Checkbox(
//           //                                 value: varDone,
//           //                                 onChanged: (value) async {
//           //                                   await updateSubject(
//           //                                       varTodo.objectId!, value!);
//           //                                   setState(() {
//           //                                     //Refresh UI
//           //                                   });
//           //                                 }),
//           //                             IconButton(
//           //                               icon: Icon(
//           //                                 Icons.delete,
//           //                                 color: Colors.blue,
//           //                               ),
//           //                               onPressed: () async {
//           //                                 await deleteSubject(varTodo.objectId!);
//           //                                 setState(() {
//           //                                   final snackBar = SnackBar(
//           //                                     content: Text("הנושא נמחק!"),
//           //                                     duration: Duration(seconds: 2),
//           //                                   );
//           //                                   ScaffoldMessenger.of(context)
//           //                                     ..removeCurrentSnackBar()
//           //                                     ..showSnackBar(snackBar);
//           //                                 });
//           //                               },
//           //                             )
//           //                           ],
//           //                         ),
//           //                       );
//           //                     });
//           //               }
//           //           }
//           //         }))
//         ],
//       ),
//     );
//   }
//
//   Future<void> saveSubject(String title) async {
//     final todo = ParseObject('Subject')..set('title', title)..set('done', false);
//     await todo.save();
//   }
//
//   Future<List<ParseObject>> getSubject() async {
//     QueryBuilder<ParseObject> querySubject =
//     QueryBuilder<ParseObject>(ParseObject('Subject'));
//     final ParseResponse apiResponse = await querySubject.query();
//
//     if (apiResponse.success && apiResponse.results != null) {
//       return apiResponse.results as List<ParseObject>;
//     } else {
//       return [];
//     }
//   }
//
//   Future<void> updateSubject(String id, bool done) async {
//     var todo = ParseObject('Subject')
//       ..objectId = id
//       ..set('done', done);
//     await todo.save();
//   }
//
//   Future<void> deleteSubject(String id) async {
//     var todo = ParseObject('Subject')..objectId = id;
//     await todo.delete();
//   }
// }