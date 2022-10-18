import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:taskify/Screens/AddList.dart';
import 'package:taskify/Storing_DB.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/util.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/validators.dart';
import 'UpdateProfile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../../firebase_options.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  File? image;

  late String namee;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
    return imageTemp;
  }

  // dialoge to choose image
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: const Text('Upload photo'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  final formKey = GlobalKey<FormState>();
  bool _isInvalid = false;
  bool _editMode = true;
  bool pressGeoON = true;
  late String firstName;
  late String lastName;
  String nameee = '';
  String photo = '';
  Future<void> getName() async {
    final res = await FirebaseFirestore.instance
        .collection('users1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      photo = res['photo'];
      nameee = res['firstName'] + ' ' + res['lastName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    getName();
    TextEditingController email = TextEditingController(
        text: '${FirebaseAuth.instance.currentUser!.email}');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              size: 30,
              color:
                  _editMode ? Color.fromARGB(0, 255, 255, 255) : Colors.white),
          onPressed: () {
            _editMode
                ? setState(() {
                    pressGeoON = !pressGeoON;
                    _editMode = !_editMode;
                    _isInvalid = false;
                  })
                : print('');
            ;
          }, // home page
        ),
        backgroundColor: Color.fromRGBO(123, 57, 237, 1),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "My profile",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          _editMode
              ? IconButton(
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
                )
              : Container(),
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
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Column(children: <Widget>[
                            _editMode
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.29,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.29,
                                          child: ClipOval(
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(
                                                  48), // Image radius
                                              child: Image.network(photo,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 0),
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
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
                                          padding: EdgeInsets.all(10.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.29,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.29,
                                          child: GestureDetector(
                                              onTap: () {
                                                _selectImage(context);
                                              }, // Image tapped

                                              child: Stack(
                                                children: <Widget>[
                                                  image == null
                                                      ? Container(
                                                          // decoration:
                                                          //     new BoxDecoration(
                                                          //         color:
                                                          //             Colors.white),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 240,

                                                          child: ClipOval(
                                                            child: SizedBox
                                                                .fromSize(
                                                              size: Size.fromRadius(
                                                                  400), // Image radius
                                                              child: Image.network(
                                                                  photo,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 240,
                                                          child: ClipOval(
                                                            child: SizedBox
                                                                .fromSize(
                                                              size: Size.fromRadius(
                                                                  400), // Image radius
                                                              child: Image.file(
                                                                  image!,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                        ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Icon(
                                                      Icons.camera_alt_rounded,
                                                      size: 30,
                                                    ),
                                                  )
                                                ],
                                              )),
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            //     color: Colors.white,
                                            //     width: 1.0),
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          width: 290,
                                          height: _isInvalid ? 65 : 40,
                                          child: TextFormField(
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            autocorrect: false,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
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
                                            textInputAction:
                                                TextInputAction.next,
                                            initialValue: nameee,
                                            // controller: _controller,
                                            // controller: name,
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
                                                return 'You cannot enter numbers and special characters !@#\%^&*()';
                                              } else if (spaceIndex! > 10 ||
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

                                            onChanged: (value) {
                                              // _controller.text = value; //
                                              // name.text = "It changed!";
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
                          Container(
                            height: 55,
                            width: 320,
                            child: ElevatedButton(
                              onPressed: () async {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    text: 'Do you want to delete your account?',
                                    confirmBtnText: 'Yes',
                                    cancelBtnText: 'No',
                                    title: "Delete Account",
                                    confirmBtnColor: Color(0xff7b39ed),
                                    onConfirmBtnTap: () async {
                                      try {
                                        await FirebaseAuth.instance.currentUser!
                                            .delete();
                                        Util.routeToWidget(
                                            context, LoginScreen());
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'requires-recent-login') {
                                          print(
                                              'The user must reauthenticate before this operation can be executed.');
                                          // Prompt the user to enter their email and password
                                          String email =
                                              'barry.allen@example.com';
                                          String password =
                                              'SuperSecretPassword!';

// Create a credential
                                          AuthCredential credential =
                                              EmailAuthProvider.credential(
                                                  email: email,
                                                  password: password);

// Reauthenticate
                                          await FirebaseAuth
                                              .instance.currentUser!
                                              .reauthenticateWithCredential(
                                                  credential);
                                        }
                                      }
                                    });
                              },
                              child: Center(
                                  child: Text("Delete Account",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ))),
                            ),
                          ),
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
                              : Column(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 320,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _editMode = !_editMode;
                                              pressGeoON = !pressGeoON;
                                            });
                                            // CoolAlert.show(
                                            //   title: "Success",
                                            //   context: context,
                                            //   type: CoolAlertType.success,
                                            //   text: "List Added successfuly!",
                                            //   confirmBtnColor:
                                            //       const Color(0xff7b39ed),
                                            // );

                                            FirebaseFirestore.instance
                                                .collection('users1')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              "firstName": firstName,
                                              "lastName": lastName,
                                            });
                                            addPhoto(
                                                image!,
                                                FirebaseAuth
                                                    .instance.currentUser!.uid);
                                          }
                                        },
                                        child: Center(
                                            child: Text("Save",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ))),
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: TextButton(
                                    //         style: TextButton.styleFrom(
                                    //           primary: Colors.grey.shade600,
                                    //           textStyle:
                                    //               const TextStyle(fontSize: 18),
                                    //         ),
                                    //         onPressed: () {
                                    //           setState(() {
                                    //             pressGeoON = !pressGeoON;
                                    //             _editMode = !_editMode;
                                    //             _isInvalid = false;
                                    //             //_isInvalid = !_isInvalid;
                                    //             print(_editMode);
                                    //           });
                                    //         },
                                    //         child: const Text(
                                    //           'Cancel',
                                    //           style: TextStyle(
                                    //             decoration:
                                    //                 TextDecoration.underline,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
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

Delete() async {
  print("Dalal");
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final useremail = _firebaseAuth.currentUser?.email;
  final userdocid = _firebaseAuth.currentUser?.uid;

  try {
    await FirebaseAuth.instance.currentUser!.delete();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      print(
          'The user must reauthenticate before this operation can be executed.');
    }
  }
// Prompt the user to enter their email and password

  String email = 'barry.allen@example.com';
  String password = 'SuperSecretPassword!';

// Create a credential
  AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: password);

// Reauthenticate
  await FirebaseAuth.instance.currentUser!
      .reauthenticateWithCredential(credential);

  /*final res1 = await _firebaseFirestore
                  .collection('users1')
                  .where("email", isEqualTo: useremail).get(); 
                  FirebaseFirestore.instance.collection("users1").where("email", isEqualTo: useremail).get();*/

  /*_firebaseFirestore.collection("users1").doc(userdocid).delete().then(
                (doc) => print("Account deleted"),
                 onError: (e) => print("Error updating document $e"),

    );  */
}
