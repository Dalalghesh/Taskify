import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:taskify/Add_Category.dart';
import 'package:taskify/InviteFriend.dart';
import 'package:taskify/received_invitations.dart';
import 'package:taskify/send_invitation.dart';
import 'package:firebase_core/firebase_core.dart';

// #7b39ed - primary color

//notifications 
Future<void> _handleBackgroundMessaging(RemoteMessage message)async{
  //on click listner
  print(message);
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //notifications 
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessaging);
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
      title: 'Flutter Demo',
      theme: ThemeData(
        iconTheme: IconThemeData(color: Color(0xff7b39ed)),
        inputDecorationTheme: InputDecorationTheme(
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
              color: Colors.grey.shade600,
            )),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black)),
        primaryColor: Color(0xff7b39ed),
        primarySwatch: primarySwatch,
      ),
      home: Add_Category(),
    );
  }
}

