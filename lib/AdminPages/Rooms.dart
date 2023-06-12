import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/AdminPages/updateRoom.dart';


class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("רשימת חדרים"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getRoom(),
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
                                final varId = snapshot.data![index]['room_id'];
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
                                              return UpdateRoomButton(roomId: snapshot.data![index]['objectId'],);
                                            },
                                            ));},

                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          deleteRoomById(snapshot.data![index]['objectId']);
                                          setState(() {
                                            final snackBar = SnackBar(
                                              content: Text("Room deleted!"),
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

  Future<List<ParseObject>> getRoom() async {
    String schoolId = await getSchoolIdFromCurrentUser();
    QueryBuilder<ParseObject> querySubject =
        QueryBuilder<ParseObject>(ParseObject('Room'));
    querySubject.whereEqualTo('schoolId', schoolId); // Add this line to filter by school ID
    final ParseResponse apiResponse = await querySubject.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }


Future<void> deleteRoomById(String roomId) async {
  final ParseObject roomObject = ParseObject('Room');
  roomObject.objectId = roomId;

  final ParseResponse response = await roomObject.delete();

  if (response.success) {
    print('Room deleted successfully');
  } else {
    throw Exception('Failed to delete room: ${response.error?.message}');
  }
}


  Future<void> updateRoom(String id, bool done) async {
  }

}