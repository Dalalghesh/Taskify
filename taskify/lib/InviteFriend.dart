import 'package:flutter/material.dart';
import 'package:taskify/Add_Category.dart';
import 'package:taskify/util.dart';
import 'package:flutter/material.dart';

import 'invitation/screens/received_invitations.dart';

class InviteFriend extends StatelessWidget {
  //const SendInstructionsView({Key? key}) : super(key: key);
  bool buttonenabled = false;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    late String email;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Util.routeToWidget(context, RecievedInvitations());
          },
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
              'Invite Friend ',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/Online world-cuate-2.png',
                  height: 200,
                  width: 200,
                )),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                'Enter your friends\' email:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
                decoration: InputDecoration(
                  hintText: 'Ex: John@gmail.com',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty)
                    return "Please enter an email";
                  else
                    return null;
                },
                onChanged: (value) {
                  email = value;
                },
                style: Theme.of(context).textTheme.subtitle1),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    //navigate to check email view
                    Util.routeToWidget(context, RecievedInvitations());
                  },
                  child: Text(
                    'Invite',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Util.routeToWidget(context, Add_Category());
                    },
                    child: const Text('Later'),
                    
                    
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
