import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:timetabler/registration/Signup.dart';
import 'package:timetabler/registration/Login.dart';

import '../DarkMode/ThemeProvider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            '                               דף ראשי',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  child: Text(
                    'הרשמה',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Signup();
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  child: Text(
                    'כניסה',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ),
                    );
                  },
                ),
              ),
            Divider(
              color: Colors.black,
              thickness: 2,
            ),
            Text('Go tabling ',
                style: TextStyle(color: Colors.red, fontSize: 20.0)),
            Text(
              'הינה מערכת שתבנה עבורכם את מערכת השעות ',
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            Text(
              '.האופטימלית עבור בית הספר שלכם',
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
          ]))),
    );
  }
}
