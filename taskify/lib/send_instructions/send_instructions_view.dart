import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/check_email/check_email_view.dart';
import 'package:taskify/util.dart';

class SendInstructionsView extends StatefulWidget {
  _SendInstructionsView createState() => _SendInstructionsView();
}

class _SendInstructionsView extends State<SendInstructionsView> {
  late String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Reset Password',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 16,
            ),
            Image.asset(
              'assets/ForgotPassword.png',
              height: 300,
              width: 300,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Enter the email associated with your account and we\'ll send an email with verification code to reset your password',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Email address',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 50,
              child: TextFormField(
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    try {
                      auth.sendPasswordResetEmail(email: _email);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Please check your email to reset your password'),
                          );
                        },
                      );
                    } on FirebaseAuthException catch (e) {
                      print(e);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(e.message.toString()),
                          );
                        },
                      );
                    }

                    //Util.routeToWidget(context, LoginPage());
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
