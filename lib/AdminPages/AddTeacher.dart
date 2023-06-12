import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import '../components/key.dart';
import 'package:timetabler/AdminPages/AfterLogin.dart';

import '../teacherPages/TeacherSchedule.dart';



class Teacher extends ParseUser implements ParseCloneable {
  List<TeacherSchedule> schedule = [];


  Teacher(String? username, String? password, String? emailAddress,
      String school_id, String subject)
      : super(username, password, emailAddress);

  String get subject => get<String>(subject)!;

  set subject(String value) => set<String>(subject, value);


}

class TeacherUser extends StatefulWidget {
  const TeacherUser({Key? key}) : super(key: key);

  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<TeacherUser> {
  late final Future<List> bannerList;




  final name = TextEditingController();
  final email = TextEditingController();
  final id_number = TextEditingController();
  final school_id = TextEditingController();
  final subject = TextEditingController();

  List<String> subjects = [];



  Future<List<ParseObject>> getSubjects() async {
    List<String> subjectsList = [];
    QueryBuilder<ParseObject> querySubject =
    QueryBuilder<ParseObject>(ParseObject('Subject'));
    final ParseResponse apiResponse = await querySubject.query();

    if (apiResponse.success && apiResponse.results != null) {
      return  apiResponse.results as List<ParseObject>;

    } else {
      return [];
    }
  }

  Future<List<String>> getSubjectsList() async {
    final subjectsDB = await getSubjects();
    for (int i = 0; i < subjectsDB.length; i++) {
      subjects.add(subjectsDB[i]["title"]);
    }
    return subjects;
  }
  //
  // setListSubjects(subjects){
  //   this.list = subjects;
  // }
  void addUser() async {
    if (name.text
        .trim()
        .isEmpty && email.text
        .trim()
        .isEmpty && id_number.text
        .trim()
        .isEmpty) {
      SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      );
      return;
    }

    await saveTeacher(
        name.text, email.text, id_number.text, school_id.text, subject.text);
    // showSuccess();
    Teacher teacher = new Teacher(
        id_number.text, id_number.text, email.text, school_id.text,
        subject.text);
    teacher.save();
    Navigator.pop(context);
  }
  String dropdownValue = "Two";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/back.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 110, top: 50),
              child: Text(
                'הוספת מורה',
                style: TextStyle(color: Color.fromARGB(255, 17, 1, 1), fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                            TextField(
                            controller: name,
                            style: TextStyle(color: Color.fromARGB(255, 9, 1, 1)),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 8, 1, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText:  'שם',
                                hintStyle: TextStyle(color: Color.fromARGB(255, 7, 1, 1)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: id_number,
                            style: TextStyle(color: Color.fromARGB(255, 11, 1, 1)),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 15, 1, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText:  'מספר מזהה',
                                hintStyle: TextStyle(color: Color.fromARGB(255, 14, 2, 2)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: email,
                            style: TextStyle(color: Color.fromARGB(255, 2, 0, 0)),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 8, 1, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Color.fromARGB(255, 7, 1, 1)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: school_id,
                            style: TextStyle(color: Color.fromARGB(255, 6, 1, 1)),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 9, 2, 2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: 'מספר מזהה של בית ספר',
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: subject,
                            style: TextStyle(color: Color.fromARGB(255, 12, 1, 1)),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 8, 1, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "'נושה לימוד'",
                                hintStyle: TextStyle(color: Color.fromARGB(255, 9, 1, 1)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'הוספה',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 7, 1, 1),
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () => addUser(),
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
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

  Future<void> saveTeacher(String name, String email, String id,
      String school_id, String Subject) async {
    final teacher = ParseObject('Teacher')
      ..set('name', name)..set('email', email)..set('id_number', id)..set(
          'school_id', school_id)..set('Subject', Subject);

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
            new TextButton(
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
