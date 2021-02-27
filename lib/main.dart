import 'package:blood_finder/pages/login.dart';
import 'package:blood_finder/pages/register.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Finder',
      routes: {
        '/login' : (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage()
      },
      theme: ThemeData(
        cursorColor: Colors.red[800],
        primaryColor: Colors.red[800],
        accentColor: Colors.red[800],
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 64.0,
              fontWeight: FontWeight.bold
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
