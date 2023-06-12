import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/AdminPages/updateSubjects.dart';


class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("רשימת נושאי לימוד"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getSubjects(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error..."),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 10.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                //*************************************
                                //Get Parse Object Value
                                final varTodo = snapshot.data![index];
                                final varId = snapshot.data![index]['title'];
                                final varDone = false;
                                //*************************************

                                return ListTile(
                                  title: Text(varId),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                    onPressed: () { Navigator.push(
                                    context,
                                    MaterialPageRoute(builder:( context) {
                                    return UpdateSubjectButton(subjectId: snapshot.data![index]['objectId'],);
                                    },
                                    ));},

                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            final snackBar = SnackBar(
                                              content: Text("הנושה נמחק!"),
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                    }
                  }))
        ],
      ),
    );
  }


  Future<String> getSchoolIdFromCurrentUser() async {
  final ParseUser currentUser = await ParseUser.currentUser();
  if (currentUser != null) {
    final String schoolId = currentUser.get('SchoolId');
    return schoolId;
  } else {
    throw Exception('No current user found.');
  }
}

  Future<List<ParseObject>> getSubjects() async {
    String schoolId = await getSchoolIdFromCurrentUser();
    QueryBuilder<ParseObject> querySubject =
        QueryBuilder<ParseObject>(ParseObject('Subject'));
    querySubject.whereEqualTo('schooId', schoolId); // Add this line to filter by school ID
    final ParseResponse apiResponse = await querySubject.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }


  Future<void> deleteSubject(String objectId) async {
    final QueryBuilder<ParseObject> querySubject =
        QueryBuilder<ParseObject>(ParseObject('Subject'));
    querySubject.whereEqualTo('objectId', objectId);

    final ParseResponse apiResponse = await querySubject.query();

    if (apiResponse.success && apiResponse.results != null) {
      print("ASdasdsad");

      final List<ParseObject> subjects =
          apiResponse.results as List<ParseObject>;

      if (subjects.isNotEmpty) {
        final ParseObject subject = subjects.first;
        await subject.delete();
      } else {
        throw Exception('Subject not found with ID: $objectId');
      }
    } else {
      throw Exception(
          'Failed to delete subject. API response: ${apiResponse.error}');
    }
  }


  Future<void> updateSubject(String id, bool done) async {
  }

}