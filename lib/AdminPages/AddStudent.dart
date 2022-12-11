import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import '../components/key.dart';


class Student extends StatefulWidget {
  @override
  _AddStudent createState() => _AddStudent();
}

class _AddStudent extends State<Student> {
  // late String name;

  final name = TextEditingController();
  final email = TextEditingController();
  final layer = TextEditingController();
  final id_number = TextEditingController();


  void addUser() async {
    if (name.text
        .trim()
        .isEmpty && email.text
        .trim()
        .isEmpty&& layer.text
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
    await saveStudent(name.text, email.text, layer.text, id_number.text);
    showSuccess();
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
                  kTextFieldDecoration.copyWith(hintText: 'Enter name.'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: id_number,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter id.'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: email,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter email.'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: layer,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter layer.'),
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

  Future<void> saveStudent(String name, String email,
      String layer, String id) async {
    final student = ParseObject('Student')
      ..set('name', name)..set('email', email)..set(
          'layer', layer)..set('id_number', id);
    await student.save();
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("Student added successfully "),
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