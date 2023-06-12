// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class UpdateRoomButton extends StatelessWidget {
  final String roomId;

  final roomid = TextEditingController();
  final numberSets = TextEditingController();
  final type = TextEditingController();

  UpdateRoomButton({required this.roomId});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('עדכון חדר'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: type,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: ' סוג החדר',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: numberSets,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: ' מספר המקומות המעודכן בחדר',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: ElevatedButton(
              child: Text('עדכן', style: TextStyle(fontSize: 20.0),),
              // color: Colors.blueAccent,
              // textColor: Colors.white,
              onPressed: () {
                updateDetails();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }



  updateDetails() async {

    String roomType = type.text;
    String roomSets = numberSets.text;
    QueryBuilder<ParseObject> queryRoom = QueryBuilder<ParseObject>(ParseObject('Room'))..whereEqualTo('objectId', roomId);
    final ParseResponse apiResponse = await queryRoom.query();

    if(type.text.isNotEmpty){
      if (apiResponse.success && apiResponse.results != null && apiResponse.results!.isNotEmpty) {
        final roomObject = apiResponse.results![0];
        roomObject.set<String>(
            'room_type', roomType);
        final updatedResponse = await roomObject.save();

        if (updatedResponse.success) {
          print('Room update saved successfully.');
        } else {
          print(
              'Error updating room: ${updatedResponse.error!.message}');
        }
      }
    }
    if(numberSets.text.isNotEmpty){
      if (apiResponse.success && apiResponse.results != null && apiResponse.results!.isNotEmpty) {
        final teacherObject = apiResponse.results![0];
        teacherObject.set<String>(
            'sets', roomSets);
        final updatedResponse = await teacherObject.save();

        if (updatedResponse.success) {
          print('Teacher update saved successfully');
        } else {
          print(
              'Error updating room: ${updatedResponse.error!.message}');
        }
      }
    }

  }

}
