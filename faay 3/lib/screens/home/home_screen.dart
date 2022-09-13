import 'package:faay/screens/auth/login_screen.dart';
import 'package:faay/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('UID: ${FirebaseAuth.instance.currentUser!.uid}'),
              const SizedBox(height: 12),
              Text('Email: ${FirebaseAuth.instance.currentUser!.email}'),
              const SizedBox(height: 12),
              Text('Name: ${FirebaseAuth.instance.currentUser!.displayName}'),
              const SizedBox(height: 12),
              Center(
                child: PrimaryButton(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  text: "Logout",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
