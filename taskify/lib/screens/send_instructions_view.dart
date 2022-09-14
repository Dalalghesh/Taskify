import 'package:flutter/material.dart';
import 'package:taskify/screens/check_email_view.dart';
import 'package:taskify/screens/login_screen.dart';
import 'package:taskify/util.dart';

class SendInstructionsView extends StatelessWidget {
  const SendInstructionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
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
              'Enter the email associated with your account and we\'ll send an email with instructions to reset your password',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Email address:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty)
                    return "Please enter an email";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: 'Ex: John@gmail.com',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
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
                    //navigate to check email view
                    Util.routeToWidget(context, CheckEmailView());
                  },
                  child: Text(
                    'Send Instructions',
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
