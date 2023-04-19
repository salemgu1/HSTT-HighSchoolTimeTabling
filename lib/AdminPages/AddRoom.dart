import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import '../components/key.dart';

const List<String> list = <String>['default', 'lab'];

class Room extends StatefulWidget {
  @override
  _Room createState() => _Room();
}

class _Room extends State<Room> {
  // late String name;
  String room_type = list.first;

  final sets = TextEditingController();
  final room_id= TextEditingController();


  void addRoom() async {
    if (sets.text.trim().isEmpty && room_id.text.trim().isEmpty && room_type.trim().isEmpty) {
      SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      );
      return;
    }
    await saveTeacher(sets.text,room_id.text,room_type);
    showSuccess();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('הוספת כיתת לימוד'),
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
                  controller: room_id,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'הכנסת מספר בכיתה'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: sets,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'הכנסת מספר כיסאות בכיתה'),
                ),
                const SizedBox(
                  height: 50.0,
                ),
            DropdownButton<String>(
              value: room_type,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  room_type = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),

                );
              }).toList(),
            ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Colors.blueAccent,
                    ),
                    onPressed: addRoom,
                    child: Text("הוספה")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveTeacher(String sets, String id,String room_type) async {
    final room = ParseObject('Room')..set('sets', sets)..set('room_id', id)..set('room_type', room_type);
    await room.save();
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("חדר כיתה נוסף בהצלחה"),
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
