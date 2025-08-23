import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFE5E5E5);
  static const Color blueLight = Color(0xFF007AFF);
  static const Color blueDark = Color(0xFF0A84FF);
  static const Color labelColor = Color(0xFF007AFF);
  static const Color cyanLight = Color(0xFF32ADE6);
  static const Color cyanDark = Color(0xFF64D2FF);
  static const Color grayLight = Color(0xFF8E8E93);
  static const Color grayDark = Color(0xFF8E8E93);
  static const Color ggray = Color(0xFF696969);
  static const Color boxFeild = Color.fromARGB(255, 228, 227, 227);
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: blueLight,
      tertiary: cyanLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );
}