import 'package:flutter/material.dart';

class CreateNewPasswordView extends StatelessWidget {
  const CreateNewPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              'Create new password',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Your new password must be different from previous used passwords.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Password',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 70,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  helperText: 'Must be at least 8 characters.',
                  helperStyle: TextStyle(fontSize: 14),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility_off),
                    onPressed: () {
                      //change icon
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Confirm Password',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 70,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  helperText: 'Both passwords must match.',
                  helperStyle: TextStyle(fontSize: 14),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility_off),
                    onPressed: () {
                      //change icon
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Reset Password',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
