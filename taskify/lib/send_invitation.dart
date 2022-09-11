import 'package:flutter/material.dart';
import 'package:taskify/check_email/check_email_view.dart';
import 'package:taskify/util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Send_invitation extends StatelessWidget {
  const Send_invitation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
         ),
           
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              ' Send Invitation',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 16,
            ),
            Image.asset(
              'assets/Online world-cuate.png',
              height: 300,
              width: 300,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Enter the email associated with thier account to send your Invitation.',
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
              child:  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex: Sara@gmail.com',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Please enter email address";
                      else
                        return null;
                    },

                    style: Theme.of(context).textTheme.subtitle1),
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
                    //Util.routeToWidget(context, CheckEmailView());
                  },
                  child: Text(
                    'Invite',
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