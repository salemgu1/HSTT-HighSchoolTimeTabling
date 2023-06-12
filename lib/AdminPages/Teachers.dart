import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/AdminPages/updateTeacher.dart';

class Teachers extends StatefulWidget {
  @override
  _TeachersState createState() => _TeachersState();
  bool isDarkMode = false;
}

class _TeachersState extends State<Teachers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("רשימת מורים"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getTeachersBySchoolId(),
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
                                // final varTodo = snapshot.data![index];
                                final teacherId =
                                    snapshot.data![index]['id_number'];
                                final teacherObjectId =
                                    snapshot.data![index]['objectId'];
                                final varName = snapshot.data![index]['name'];
                                final teacherEmail =
                                    snapshot.data![index]['email'];
                                final varDone = false;
                                //*************************************

                                return ListTile(
                                  title: Text(teacherId),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return UpdateTeacherDetailsButton(
                                                teacherId: snapshot.data![index]
                                                    ['objectId'],
                                              );
                                            },
                                          ));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await deleteTeacher(teacherObjectId);

                                            setState(() {
                                              final snackBar = SnackBar(
                                                content: Text("המורה נמחק!"),
                                                duration: Duration(seconds: 2),
                                              );
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                            });
                                          } catch (e) {
                                            setState(() {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    "Failed to delete teacher: $e"),
                                                duration: Duration(seconds: 2),
                                              );
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                            });
                                          }
                                        },
                                      ),
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

  Future<List<ParseObject>> getTeachersBySchoolId() async {
    String schoolId = await getSchoolIdFromCurrentUser();
    QueryBuilder<ParseObject> queryTeacher =
        QueryBuilder<ParseObject>(ParseObject('Teacher'));
    queryTeacher.whereEqualTo(
        'school_id', schoolId); // Add this line to filter by school ID
    final ParseResponse apiResponse = await queryTeacher.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
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

  Future<void> deleteTeacher(String objectId) async {

    final QueryBuilder<ParseObject> queryTeacher =
        QueryBuilder<ParseObject>(ParseObject('Teacher'));
    queryTeacher.whereEqualTo('objectId', objectId);

    final ParseResponse apiResponse = await queryTeacher.query();

    if (apiResponse.success && apiResponse.results != null) {
      print("ASdasdsad");

      final List<ParseObject> teachers =
          apiResponse.results as List<ParseObject>;

      if (teachers.isNotEmpty) {
        final ParseObject teacher = teachers.first;
        await teacher.delete();
      } else {
        throw Exception('Teacher not found with ID: $objectId');
      }
    } else {
      throw Exception(
          'Failed to delete teacher. API response: ${apiResponse.error}');
    }
  }



  Future<void> updateTeacher(String id, bool done) async {}
}
