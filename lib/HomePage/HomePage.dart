import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/registration/Signup.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter FlatButton Example'),
          ),
          body: Center(child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('SignUp', style: TextStyle(fontSize: 20.0),),
                onPressed: () {                Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Signup();
                    },
                    ));},
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('LogIn', style: TextStyle(fontSize: 20.0),),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {                Navigator.push(
                    context,
                    MaterialPageRoute(builder:( context) {
                      return Signup();
                    },
                    ));},
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
            )
          ]
          ))

      ),
    );
  }
}