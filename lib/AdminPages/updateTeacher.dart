import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class UpdateTeacherDetailsButton extends StatelessWidget {
  final String teacherId;

  final subject = TextEditingController();
  final name = TextEditingController();

  UpdateTeacherDetailsButton({required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: name,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: subject,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the subject ',
            ),
          ),
        ),
      Container(
      margin: EdgeInsets.all(25),
      child: ElevatedButton(
      child: Text('Update', style: TextStyle(fontSize: 20.0),),
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

    String teacherName = name.text;
    String teacherSubject = subject.text;
    QueryBuilder<ParseObject> queryTeacher = QueryBuilder<ParseObject>(ParseObject('Teacher'))..whereEqualTo('objectId', teacherId);
    final ParseResponse apiResponse = await queryTeacher.query();

    if(name.text.isNotEmpty){
      print(name.text);
      if (apiResponse.success && apiResponse.results != null && apiResponse.results!.isNotEmpty) {
        final teacherObject = apiResponse.results![0];
        teacherObject.set<String>(
            'name', teacherName);
        final updatedResponse = await teacherObject.save();

        if (updatedResponse.success) {
          print('Teacher update saved successfully.');
        } else {
          print(
              'Error updating teacher: ${updatedResponse.error!.message}');
        }
      }
    }
    if(subject.text.isNotEmpty){
      if (apiResponse.success && apiResponse.results != null && apiResponse.results!.isNotEmpty) {
        final teacherObject = apiResponse.results![0];
        teacherObject.set<String>(
            'Subject', teacherSubject);
        final updatedResponse = await teacherObject.save();

        if (updatedResponse.success) {
          print('Teacher update saved successfully.');
        } else {
          print(
              'Error update teacher: ${updatedResponse.error!.message}');
        }
      }
    }

  }

}
