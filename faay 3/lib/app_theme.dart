import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
    )),
    colorScheme: const ColorScheme.light().copyWith(primary: Colors.deepPurple),
    primaryColor: Colors.deepPurple,

    // ignore: prefer_const_constructors
    textTheme: TextTheme(
      headline1: const TextStyle(
        fontSize: 32,
        fontFamily: "Ubuntu-Medium.ttf",
        color: Colors.black,
      ),
      headline2: const TextStyle(
        fontSize: 17,
        fontFamily: "Ubuntu-Regular.ttf",
        color: Colors.black54,
      ),
      headline3: const TextStyle(
        fontSize: 24,
        fontFamily: "Ubuntu-Medium.ttf",
        color: Colors.white,
      ),
      headline4: const TextStyle(
        fontSize: 36,
        fontFamily: "Ubuntu-Medium.ttf",
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      headline5: const TextStyle(
          fontSize: 24,
          fontFamily: "Ubuntu-Medium.ttf",
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w500),
      button: const TextStyle(
        fontSize: 25,
        fontFamily: "Ubuntu-Medium.ttf",
        color: Colors.deepPurple,
      ),
      headline6: const TextStyle(
        fontSize: 25,
        fontFamily: "Ubuntu-Medium.ttf",
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ).apply(fontFamily: "Ubuntu"),
  );
}
