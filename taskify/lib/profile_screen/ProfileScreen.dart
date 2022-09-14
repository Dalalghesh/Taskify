import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/util.dart';

class ProfileScreen extends StatefulWidget {
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
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
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: 200,
              margin: EdgeInsets.only(top: 30),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/Avatar.png',
                    height: 300,
                    width: 300,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Lama Al-watban',
                style: TextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(height: 5),
            Text(
              'lamaalwatban@gmail.com',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      text: 'Do you want to logout',
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      confirmBtnColor: Colors.green,
                      onConfirmBtnTap: () => FirebaseAuth.instance.signOut(),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ],
            )
            /*ProfileListItem(
              icon: LineAwesomeIcons.alternate_sign_out,
              text: 'Logout',
              hasNavigation: true,
            ),*/
          ],
        ),
      ),
    );
  }
}
