import 'package:flutter/material.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/send_instructions/send_instructions_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:taskify/onboarding/onboarding_screen.dart';
// #7b39ed - primary color

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MaterialColor primarySwatch = MaterialColor(0xff7b39ed, <int, Color>{
    50: Color(0xff7b39ed),
    100: Color(0xff7b39ed),
    200: Color(0xff7b39ed),
    300: Color(0xff7b39ed),
    400: Color(0xff7b39ed),
    500: Color(0xff7b39ed),
    600: Color(0xff7b39ed),
    700: Color(0xff7b39ed),
    800: Color(0xff7b39ed),
    900: Color(0xff7b39ed),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskify',
      theme: ThemeData(
        iconTheme: IconThemeData(color: Color(0xff7b39ed)),
        inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
            //contentPadding: EdgeInsets.all(10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
        ),
        textTheme: TextTheme(
            headline4:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            subtitle1: TextStyle(
              color: Colors.black,
            )),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black)),
        primaryColor: Color(0xff7b39ed),
        primarySwatch: primarySwatch,
      ),
      home: LoginScreen(),
    );
  }
}
