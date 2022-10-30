import 'package:flutter/material.dart';
import 'package:taskify/send_instructions/send_instructions_view.dart';
import 'package:taskify/util.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:taskify/Screens/auth/login_screen.dart';

class CheckEmailView extends StatefulWidget {
  _CheckEmailView createState() => _CheckEmailView();
}

class _CheckEmailView extends State<CheckEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/msg.png',
                      height: 300,
                      width: 300,
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Check your mail',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'We have sent you an email to reset your password please check your email,after resting your password please click next',
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        //navigate to check login page
                        Util.routeToWidget(context, LoginScreen());
                      },
                      child: Text(
                        'next',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Did not receive the email? Check your spam filter,'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('or'),
                    TextButton(
                      child: Text('try another email address'),
                      onPressed: () {
                        Util.routeToWidget(context, SendInstructionsView());
                      },
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
