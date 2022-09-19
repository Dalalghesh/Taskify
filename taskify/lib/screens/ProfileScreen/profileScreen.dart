import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  Widget textfield({@required hintText}) {
    return Material(
      // elevation: 4,
      // shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // child: TextField(
      //   decoration: InputDecoration(
      //       hintText: hintText,
      //       hintStyle: TextStyle(
      //         letterSpacing: 2,
      //         color: Colors.black54,
      //         //  fontWeight: FontWeight.bold,
      //       ),
      //       fillColor: Colors.white30,
      //       filled: true,
      //       contentPadding: EdgeInsets.symmetric(
      //         vertical: 10,
      //         horizontal: 10,
      //       ),
      //       border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(10.0),
      //           borderSide: BorderSide.none)),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(123, 57, 237, 1),
        leading: IconButton(
          padding: EdgeInsets.only(
            left: 380,
          ),
          icon: Icon(
            Icons.logout_outlined,
            color: Color.fromRGBO(255, 255, 255, 1),
            size: 30,
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 550,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 19,
                    ),
                    Text(
                      '${FirebaseAuth.instance.currentUser!.displayName}',
                      style: TextStyle(
                        fontSize: 25,
                        //letterSpacing: 1.5,
                        color: Color.fromARGB(255, 0, 0, 0),
                        //   fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${FirebaseAuth.instance.currentUser!.email}',
                      style: TextStyle(
                        fontSize: 18,
                        //letterSpacing: 1.5,
                        color: Color.fromARGB(255, 0, 0, 0),
                        //   fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            "Update",
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
              )
            ],
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
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
                    //letterSpacing: 1.5,
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
                    image: AssetImage('assets/user-5.png'),
                  ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(bottom: 300, left: 164),
          //   child: CircleAvatar(
          //     backgroundColor: Color(0xff7b39ed),
          //     child: IconButton(
          //       icon: Icon(
          //         Icons.edit,
          //         color: Colors.white,
          //       ),
          //       onPressed: () {},
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
  //@override
  //Widget build(BuildContext context) {
  // return Scaffold(
  //   body: SafeArea(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text('UID: ${FirebaseAuth.instance.currentUser!.uid}'),
  //           const SizedBox(height: 12),
  //           Text('Email: ${FirebaseAuth.instance.currentUser!.email}'),
  //           const SizedBox(height: 12),
  //           Text('Name: ${FirebaseAuth.instance.currentUser!.displayName}'),
  //           const SizedBox(height: 12),
  //           Center(
  //             child: PrimaryButton(
  //               onTap: () async {
  //                 await FirebaseAuth.instance.signOut();
  //                 Navigator.of(context).pushReplacement(
  //                   MaterialPageRoute(builder: (context) => const LoginScreen()),
  //                 );
  //               },
  //               text: "Logout",
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   ),
  // );
  //}
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
