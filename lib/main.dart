import 'package:flutter/material.dart';
import 'package:internship_tracker/core/app_theme.dart' as app_theme;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internship_tracker/features/home_page.dart';
import 'package:internship_tracker/features/login_page.dart';
import 'package:internship_tracker/features/signup_page.dart';

final storage = FlutterSecureStorage();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interhship Tracker',
      theme: app_theme.AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: storage.read(key: 'token'),
        builder: (context, snapchot) {
          if (snapchot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
           /* if (snapchot.hasData && snapchot.data != null) // has token
            {
              return HomePage(token: snapchot.data.toString());
            } else {
              return SignUp();
            }*/
            return SignIn();
          }
        },
      ),
    );
  }
}
