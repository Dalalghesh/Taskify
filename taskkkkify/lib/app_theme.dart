import 'dart:html';

import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
    ),
    colorScheme: const ColorScheme.light().copyWith(primary: Colors.deepPurple),
    primaryColor: Colors.deepPurple,

    // ignore: prefer_const_constructors
    /*textTheme: TextTheme(
        headline1: const TextStyle(
          fontSize: 32,
          color: Colors.black,
        ),
        headline2: const TextStyle(
          fontSize: 17,
          color: Colors.black54,
        ),
        headline3: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
        headline4: const TextStyle(
          fontSize: 36,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        headline5: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500),
        button: const TextStyle(
          fontSize: 25,
          color: Colors.deepPurple,
        ),
        headline6: const TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ));*/
    textTheme: TextTheme(
        headline4: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        subtitle1: TextStyle(
          color: Colors.grey.shade600,
        )),
  );
}
