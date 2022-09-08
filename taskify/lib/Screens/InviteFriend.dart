import 'package:flutter/material.dart';
import 'package:taskify/util.dart';

import 'AddTask.dart';

class InviteFriend extends StatelessWidget {
  //const SendInstructionsView({Key? key}) : super(key: key);
  bool buttonenabled = false;
  String? selectedValue;

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
              'Invite Friend ',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Enter your friends\' email:',
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
                    Util.routeToWidget(context, AddTask());
                  },
                  child: Text(
                    'Invite',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
