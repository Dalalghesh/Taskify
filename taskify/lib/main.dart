import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/invitation/provider/invitation.dart';
import 'package:taskify/screens/send_instructions_view.dart';
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
  static const int _deepPurplePrimaryValue = 0xFF673AB7;

  final MaterialColor primarySwatch = MaterialColor(0xff7b39ed, <int, Color>{
    50: Color(0xFFEDE7F6),
    100: Color(0xFFD1C4E9),
    200: Color(0xFFB39DDB),
    300: Color(0xFF9575CD),
    400: Color(0xFF7E57C2),
    500: Color(_deepPurplePrimaryValue),
    600: Color(0xFF5E35B1),
    700: Color(0xFF512DA8),
    800: Color(0xFF4527A0),
    900: Color(0xFF311B92),
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InvitaitonProvider())
      ],
      child: ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
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
                  color: Color.fromARGB(255, 0, 0, 0),
                )),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black)),
            primaryColor: Color(0xff7b39ed),
            primarySwatch: primarySwatch,
          ),
          home: OnboardingScreen(),
        ),
      ),
    );
  }
}
