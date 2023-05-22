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

const List<String> list = <String>['default', 'lab'];

class Room extends StatefulWidget {
  const Room({Key? key}) : super(key: key);

  @override
  _AddStudent createState() => _AddStudent();
}

class _AddStudent extends State<Room> {
  String room_type = list.first;

  final sets = TextEditingController();
  final room_id = TextEditingController();

  void addRoom() async {
    if (sets.text.trim().isEmpty &&
        room_id.text.trim().isEmpty &&
        room_type.trim().isEmpty) {
      SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      );
      return;
    }
    await saveRoom(sets.text, room_id.text, room_type);
    showSuccess();
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
        backgroundColor: Color.fromARGB(0, 202, 11, 11),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 187, 11, 11),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 110, top: 50),
              child: Text(
                'הוספת כיתה',
                style: TextStyle(color: Colors.black, fontSize: 33),
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
                            controller: room_id,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: ' מספר בכיתה',
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: sets,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: 'הכנסת מספר כיסאות בכיתה',
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          DropdownButton<String>(
                            value: room_type,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                room_type = value!;
                              });
                            },
                            
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black,
                            isExpanded: true,
                            itemHeight: 50.0,
                            hint: Text(
                              'בחר סוג כיתה',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            selectedItemBuilder: (BuildContext context) {
                              return list.map<Widget>((String item) {
                                return Text(
                                  room_type,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'הוספה',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () => addRoom(),
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

  Future<void> saveRoom(String sets, String id, String room_type) async {
    final room = ParseObject('Room')
      ..set('sets', sets)
      ..set('room_id', id)
      ..set('room_type', room_type);
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
