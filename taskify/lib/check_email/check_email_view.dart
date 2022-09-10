import 'package:flutter/material.dart';
import 'package:taskify/create_new_password/create_new_password_view.dart';
import 'package:taskify/send_instructions/send_instructions_view.dart';
import 'package:taskify/util.dart';

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
                          'We have sent one time password to your email. Please write it there.',
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
                Container(
                  height: 50,
                  child: TextFormField(
                    //controller: emailController,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        //navigate to check email view
                        Util.routeToWidget(context, CreateNewPasswordView());
                      },
                      child: Text(
                        'Verify',
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
