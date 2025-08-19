import 'package:flutter/material.dart';
import 'package:internship_tracker/core/app_theme.dart' as app_theme;
import 'package:internship_tracker/features/home_page.dart';
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
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
