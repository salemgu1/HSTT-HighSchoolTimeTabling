import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/AdminPages/updateTeacher.dart';


class Teachers extends StatefulWidget {
  @override
  _TeachersState createState() => _TeachersState();
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
                  future: getTeacher(),
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
                                final teacherId = snapshot.data![index]['id_number'];
                                final teacherObjectId = snapshot.data![index]['objectId'];
                                final varName = snapshot.data![index]['name'];
                                final teacherEmail = snapshot.data![index]['email'];
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
                                    onPressed: () { Navigator.push(
                                    context,
                                    MaterialPageRoute(builder:( context) {
                                    return UpdateTeacherDetailsButton(teacherId: snapshot.data![index]['objectId'],);
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
                                              content: Text("המורה נמחק!"),
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          });
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

  Future<List<ParseObject>> getTeacher() async {
    QueryBuilder<ParseObject> queryTeacher =
    QueryBuilder<ParseObject>(ParseObject('Teacher'));
    final ParseResponse apiResponse = await queryTeacher.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }


  Future<List> deleteTeacher(String teacherEmail) async {
    QueryBuilder<ParseUser> queryUsers =
    QueryBuilder<ParseUser>(ParseUser.forQuery());
    final ParseResponse apiResponse = await queryUsers.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (int i = 0; i < apiResponse.results!.length; i++) {
        if (apiResponse.results![i].email == teacherEmail) {
          print("adasdasdas");
        }
      }
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }


    // final user = ParseObject('User')..objectId = ;
    // final teacher = ParseObject('Teacher')..objectId = teacherId;
    //
    // try {
    //   await teacher.delete();
    //   print('Teacher deleted successfully.');
    // } catch (e) {
    //   print('Error deleting teacher: ${e.toString()}');
    // }

  }


  Future<void> updateTeacher(String id, bool done) async {
  }

}