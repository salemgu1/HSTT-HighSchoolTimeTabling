import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timetabler/HomePage/HomePage.dart';
import 'package:timetabler/registration/ResetPassword.dart';
import 'package:timetabler/AdminPages/AfterLogin.dart';
import '../AdminPages/AddTeacher.dart';
import 'package:timetabler/registration/Signup.dart';
import '../AdminPages/AddRoom.dart';
import '../MaxSat/Schedule.dart';
import '../teacherPages/TeacherSchedule.dart';
import '../teacherPages/teacherAfterLoginPage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'ברוכים הבאים',
                style: TextStyle(color: textColor, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: controllerUsername,
                            enabled: !isLoggedIn,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              fillColor: backgroundColor,
                              filled: true,
                              hintText: "Email",
                              hintStyle: TextStyle(color: hintTextColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: controllerPassword,
                            enabled: !isLoggedIn,
                            style: TextStyle(color: textColor),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: backgroundColor,
                              filled: true,
                              hintText: "Password",
                              hintStyle: TextStyle(color: hintTextColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'כניסה',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed:
                                      isLoggedIn ? null : () => doUserLogin(),
                                  icon: Icon(Icons.arrow_forward),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Signup();
                                    },
                                  ));
                                },
                                child: Text(
                                  'להירשם כאן',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18,
                                  ),
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ResetPassword();
                                    },
                                  ));
                                },
                                child: Text(
                                  'שכחתי סיסמה',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Remaining methods..

  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error11111!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();
    List<String> teachers = [];
    List<String> students = [];
    final teathersDB = await getTeacher();

    for (int i = 0; i < teathersDB.length; i++) {
      teachers.add(teathersDB[i]["id_number"]);
    }

    if (response.success) {
      if (teachers.contains(user.username)) {
        print(user.username);
        Navigator.push(
          // SchedulePage
          // teacherAfterLogin
          context,
          MaterialPageRoute(
            builder: (context) => teacherAfterLogin(),
          ),
        );
        setState(() {
          isLoggedIn = true;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AfterLogin(),
          ),
        );
        setState(() {
          isLoggedIn = true;
        });
      }
    } else {
      showError(response.error!.message);
    }
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

  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();

    if (response.success) {
      showSuccess("User was successfully logout!");
      setState(() {
        isLoggedIn = false;
      });
    } else {
      showError(response.error!.message);
    }
  }

  void doUserResetPassword() async {
    final ParseUser user = ParseUser(null, null, controllerEmail.text.trim());
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (parseResponse.success) {
      showSuccess('Password reset instructions have been sent to email!');
    } else {
      showError(parseResponse.error!.message);
    }
  }
}
