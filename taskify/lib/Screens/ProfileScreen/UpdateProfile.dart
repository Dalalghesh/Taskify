import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'UpdateProfile.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController(
        text: '${FirebaseAuth.instance.currentUser!.email}');
    TextEditingController name = TextEditingController(
        text: '${FirebaseAuth.instance.currentUser!.displayName}');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(123, 57, 237, 1),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }, // home page
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       height: 530,
          //       width: double.infinity,
          //       margin: EdgeInsets.symmetric(horizontal: 10),
          //       child: Column(
          //         children: [
          //           SizedBox(
          //             height: 115,
          //           ),
          //           Text(
          //             '${FirebaseAuth.instance.currentUser!.displayName}',
          //             style: TextStyle(
          //               fontSize: 25,
          //               color: Color.fromARGB(255, 0, 0, 0),
          //             ),
          //           ),
          //           Text(
          //             '${FirebaseAuth.instance.currentUser!.email}',
          //             style: TextStyle(
          //               fontSize: 18,
          //               color: Color.fromARGB(255, 0, 0, 0),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 50,
          //           ),
          //           Container(
          //             height: 55,
          //             width: double.infinity,
          //             child: ElevatedButton(
          //               onPressed: () {},
          //               child: Center(
          //                 child: Text(
          //                   "Update",
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           )
          //         ],
          //       ),
          //     )
          //   ],
          // ),
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
                  "Update profile",
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
                          'https://cdn-icons-png.flaticon.com/512/847/847969.png')

                      //    AssetImage('assets/user-5.png'),
                      ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 290,
                height: 30,
                child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    controller: name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.edit),
                      prefixIconConstraints: BoxConstraints(maxWidth: 0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7b39ed)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7b39ed)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7b39ed)),
                      ),
                    )),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 290,
                height: 30,
                child: TextField(
                    textAlign: TextAlign.center,
                    controller: email,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    decoration: InputDecoration(
                      prefixIconConstraints: BoxConstraints(maxWidth: 0),
                      prefixIcon: Icon(Icons.edit),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7b39ed)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7b39ed)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7b39ed)),
                      ),
                    )),
              ),
              // Text(
              //   '${FirebaseAuth.instance.currentUser!.displayName}',
              //   style: TextStyle(
              //     fontSize: 25,
              //     color: Color.fromARGB(255, 0, 0, 0),
              //   ),
              // ),
              // Text(
              //   '${FirebaseAuth.instance.currentUser!.email}',
              //   style: TextStyle(
              //     fontSize: 18,
              //     color: Color.fromARGB(255, 0, 0, 0),
              //   ),
              // ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 55,
                width: 320,
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
              // Positioned(
              //     bottom: 100000,
              //     right: 5550,
              //     child: Container(
              //       margin: const EdgeInsets.only(
              //           top: 1, bottom: 200, left: 90.0, right: 20.0),
              //       height: 40,
              //       width: 30,
              //       decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           border: Border.all(width: 2, color: Colors.white),
              //           color: Colors.red),
              //     ))
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
