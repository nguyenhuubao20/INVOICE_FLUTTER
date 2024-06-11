import 'package:flutter/material.dart';

class ThemeColor {
  static Color primary = Colors.red;
  static Color blue = Colors.blue;
  static Color teal = Colors.teal;
  static Color green = Colors.green;
  static Color yellow = Colors.yellow;
  static Color orange = Colors.orange;
  static Color pink = Colors.pink;
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff8FBEFF)),
    scaffoldBackgroundColor: const Color(0xffF9F9F9),
    brightness: Brightness.light,
    fontFamily: 'Arial',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff8FBEFF), // Màu của các nút bấm
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xff8FBEFF)),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff8FBEFF), brightness: Brightness.dark),
    scaffoldBackgroundColor: Colors.grey[900],
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff8FBEFF), // Màu của các nút bấm
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xff8FBEFF)),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
      ),
    ),
  );
}
