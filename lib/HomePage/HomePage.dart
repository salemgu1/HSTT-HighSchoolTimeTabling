import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetabler/registration/Signup.dart';
import 'package:timetabler/registration/Login.dart';
import '../DarkMode/ThemeProvider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('דף ראשי'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
            ),
            onPressed: () {
              themeProvider.toggleDarkMode();
            },
          ),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60),
          Image.asset(
            'assets/homePageBack.png',
            width: 400,
            height: 300,
          ),
          SizedBox(height: 20),
          Text(
            'Go tabling',
            style: TextStyle(color: Colors.red, fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'הינה מערכת שתבנה עבורכם את מערכת השעות',
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              '.האופטימלית עבור בית הספר שלכם',
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: ElevatedButton(
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
              child: Text(
                'הרשמה',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: OutlinedButton(
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
              child: Text(
                'כניסה',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
