import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/navigation.dart';
//import 'package:spincircle_bottom_bar/modals.dart';
//import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskify App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeBottom(),
    );
  }
}

class HomeBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => navigationstate()));
                },
                child: const Text(
                  "SpinCircle",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
