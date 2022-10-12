import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:taskify/Screens/AddList.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/util.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'UpdateProfile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  bool _editMode = false;
  bool pressGeoON = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController(
        text: '${FirebaseAuth.instance.currentUser!.email}');
    TextEditingController name = TextEditingController(
        text: '${FirebaseAuth.instance.currentUser!.displayName}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(123, 57, 237, 1),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.transparent),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(
              right: 15,
            ),
            onPressed: () async {
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  text: 'Do you want to logout?',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  title: "Logout",
                  confirmBtnColor: Color(0xff7b39ed),
                  onConfirmBtnTap: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  });
            },
            icon: Icon(
              Icons.logout_outlined,
              color: Color.fromRGBO(255, 255, 255, 1),
              size: 30,
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 530,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Column(children: <Widget>[
                      _editMode
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text(
                                    '${FirebaseAuth.instance.currentUser!.displayName}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  Text(
                                    '${FirebaseAuth.instance.currentUser!.email}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  )
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Container(
                                    width: 290,
                                    height: 30,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff7b39ed)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff7b39ed)),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff7b39ed)),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      controller: name,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${FirebaseAuth.instance.currentUser!.email}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  )
                                ])
                    ]),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "My profile",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2.29,
                height: MediaQuery.of(context).size.width / 2.29,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/847/847969.png')),
                ),
              ),
              SizedBox(
                height: 104,
              ),
              Container(
                height: 55,
                width: 320,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _editMode = !_editMode;
                      pressGeoON = !pressGeoON;
                    });
                    // Util.routeToWidget(context, UpdateProfile());
                  },
                  child: Center(
                    child: pressGeoON
                        ? Text("Update",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ))
                        : Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff7b39ed);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
