import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:taskify/Screens/AddList.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/util.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/validators.dart';
import 'UpdateProfile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late String namee;

  final formKey = GlobalKey<FormState>();
  bool _isInvalid = false;
  bool _editMode = false;
  bool pressGeoON = false;
  late String firstName;
  late String lastName;
  String nameee = '';
  Future<void> getName() async {
    final res = await FirebaseFirestore.instance
        .collection('users1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      nameee = res['firstName'] + ' ' + res['lastName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    getName();
    TextEditingController email = TextEditingController(
        text: '${FirebaseAuth.instance.currentUser!.email}');
    var name = TextEditingController(text: nameee);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(123, 57, 237, 1),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "My profile",
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
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
          Container(
            child: Form(
              key: formKey,
              child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "",
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
                    // SizedBox(
                    //   height: 104,
                    // ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      // height: 530,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          // SizedBox(
                          //   height: 50,
                          // ),
                          Column(children: <Widget>[
                            _editMode
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Text(
                                          nameee,
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
                                          height: _isInvalid ? 65 : 40,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              // errorStyle: const TextStyle(
                                              //     fontSize: 0.01),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10.0),
                                            ),

                                            style: TextStyle(
                                              fontSize: 25,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            //   controller: name,
                                            //   validator: Validators.emptyValidator,
                                            validator: (value) {
                                              _isInvalid = false;

                                              final regExp =
                                                  RegExp(r'^[a-zA-Z ]+$');

                                              int? spaceIndex =
                                                  value?.indexOf(' ');
                                              if (spaceIndex == -1) {
                                                setState(() {
                                                  _isInvalid = true;
                                                });
                                                return "Please enter your first and last name";
                                              } else if (!regExp
                                                  .hasMatch(value!.trim())) {
                                                setState(() {
                                                  _isInvalid = true;
                                                });
                                                return 'You cannot enter special characters !@#\%^&*()';
                                              }
                                              //   name.text = value!;

                                              else if (spaceIndex! > 10 ||
                                                  value.length > 21) {
                                                setState(() {
                                                  _isInvalid = true;
                                                });
                                                return 'Name must be maximum 10 characters';
                                              } else {
                                                firstName = value.substring(
                                                    0, spaceIndex);
                                                lastName = value
                                                    .substring(spaceIndex + 1);
                                                print(firstName);
                                                print(lastName);
                                              }
                                              return null;
                                            },

                                            onChanged: (value) async {
                                              //  name.text = value;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
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
                            height: 20,
                          ),
                          pressGeoON
                              ? Container(
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
                                        child: Text("Update",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ))),
                                  ),
                                )
                              : Container(
                                  height: 55,
                                  width: 320,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          _editMode = !_editMode;
                                          pressGeoON = !pressGeoON;
                                        });
                                        FirebaseFirestore.instance
                                            .collection('users1')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "firstName": firstName,
                                          "lastName": lastName,
                                        });
                                        // FirebaseFirestore.instance
                                        //     .collection('users1')
                                        //     .doc('g7YRfNDuxNN8SftgUUIOuDDdJvt1')
                                        //     .set({'firstName': firstName});
                                        CoolAlert.show(
                                          title: "Success",
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "List Added successfuly!",
                                          confirmBtnColor:
                                              const Color(0xff7b39ed),
                                        );
                                      }
                                    },
                                    child: Center(
                                        child: Text("Save",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ))),
                                  ),
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ]), //key for form
            ),
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
