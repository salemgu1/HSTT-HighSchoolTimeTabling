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


// const List<String> list = []




class Teacher extends ParseUser implements ParseCloneable {
  List<TeacherSchedule> schedule = [];


  Teacher(String? username, String? password, String? emailAddress,
      String school_id, String subject)
      : super(username, password, emailAddress);

  String get subject => get<String>(subject)!;

  set subject(String value) => set<String>(subject, value);


}

class TeacherUser extends StatefulWidget {
  @override
  _AddTeacherUser createState() => _AddTeacherUser();
}

class _AddTeacherUser extends State<TeacherUser> {
  // late String name;

  late final Future<List> bannerList;




  final name = TextEditingController();
  final email = TextEditingController();
  final id_number = TextEditingController();
  final school_id = TextEditingController();
  final subject = TextEditingController();
  // late String subjectSelected;
  // List<String> subjects = [
  //   'Math',
  //   'Science',
  //   'History',
  //   'English'
  // ];
  //
  List<String> subjects = [];
  // Replace with your list of subjects
  // List<String> list = <String>['One', 'Two', 'Three', 'Four'];



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
  // getSubjects().then((value) => setListSubjects(value));
  //   getSubjectsList();
    late List<String> list = [];

    (getSubjectsList().then((value) => list = value ));


    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('הוספת מורה'),
        ),
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
                kTextFieldDecoration.copyWith(hintText: 'שם'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: id_number,
                autofocus: true,
                textAlign: TextAlign.center,
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'מספר מזהה'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: email,
                autofocus: true,
                textAlign: TextAlign.center,
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Email'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: school_id,
                autofocus: true,
                textAlign: TextAlign.center,
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'מספר מזהה של בית ספר'),
              ),
              const SizedBox(
                height: 20.0,
              ),
                  TextField(
                    controller: subject,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration:
                    kTextFieldDecoration.copyWith(hintText: 'נושה לימוד'),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
        const SizedBox(
        height: 20.0,
      ),
      ElevatedButton(
        child: const Text('הוספה'),
        onPressed: () {
          addUser();
          Navigator.pop(context);
        },
      ),
      ],
    ),)
    ,
    )
    ,
    )
    ,
    );

  }

  Future<void> saveTeacher(String name, String email, String id,
      String school_id, String Subject) async {
    print(Subject);
    final teacher = ParseObject('Teacher')
      ..set('name', name)..set('email', email)..set('id_number', id)..set(
          'school_id', school_id)..set('Subject', Subject);
    print(teacher["email"]);
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

