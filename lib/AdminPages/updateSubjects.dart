import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class UpdateSubjectButton extends StatelessWidget {
  final String subjectId;

  final subject = TextEditingController();

  UpdateSubjectButton({required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
     appBar: AppBar(
        title: Text('עדכון נושה'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              child: Text(
                'Update',
                style: TextStyle(fontSize: 20.0),
              ),
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
    String newSubject = subject.text;
    QueryBuilder<ParseObject> queryTeacher =
        QueryBuilder<ParseObject>(ParseObject('Subject'))
          ..whereEqualTo('objectId', subjectId);
    final ParseResponse apiResponse = await queryTeacher.query();
    if (subject.text.isNotEmpty) {
      if (apiResponse.success &&
          apiResponse.results != null &&
          apiResponse.results!.isNotEmpty) {
        final subjectObject = apiResponse.results![0];
        subjectObject.set<String>('title', newSubject);
        final updatedResponse = await subjectObject.save();

        if (updatedResponse.success) {
          print('Teacher update saved successfully.');
        } else {
          print('Error update teacher: ${updatedResponse.error!.message}');
        }
      }
    }
  }
}
