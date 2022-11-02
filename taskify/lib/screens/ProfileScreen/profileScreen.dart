import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';
import 'package:taskify/Screens/AddList.dart';
import 'package:taskify/Storing_DB.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/util.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../appstate.dart';
import '../../models/tasks.dart';
import '../../screens/tasks_screen.dart';
import '../../screens/todo_list_screen.dart';
import '../../utils/validators.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../../firebase_options.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
    getList();
  }

  File? image;

  late String namee;

  getList() async {
    // print(widget.category);
    await Future.delayed(Duration(milliseconds: 100));
    await Provider.of<AppState>(this.context, listen: false).getListAll();
    await Provider.of<AppState>(this.context, listen: false)
        .getAllTasksProfile();
    await Provider.of<AppState>(this.context, listen: false).linkData();
  }

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
    if (mounted) {
      setState(() {
        try {
          photo = res['photo'];
        } catch (e) {
          photo = "";
        }
        nameee = res['firstName'] + ' ' + res['lastName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //AppState provider = Provider.of<AppState>(context);
    getName();
    // TextEditingController email = TextEditingController(
    //     text: '${FirebaseAuth.instance.currentUser!.email}');
    AppState provider = Provider.of<AppState>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Container(
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
            child: Center(child: Icon(!_editMode ? Icons.save : Icons.edit)

                // Text("Update",
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: Colors.white,
                //     ))

                ),
          ),
        ),

        ///
        // IconButton(
        //   icon: Icon(Icons.arrow_back,
        //       size: 30,
        //       color:
        //           _editMode ? Color.fromARGB(0, 255, 255, 255) : Colors.white),
        //   onPressed: () {
        //     _editMode
        //         ? print('')
        //         : setState(() {
        //             pressGeoON = !pressGeoON;
        //             _editMode = !_editMode;
        //             _isInvalid = false;
        //           });
        //   }, // home page
        // ),
        backgroundColor: Color.fromRGBO(123, 57, 237, 1),
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "My Profile",
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
                    showAlertDialog(context);
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
      body: buildColumn(context, provider),
      // body: buildColumnOld(context, provider),
    );
  }

  Widget buildColumn(BuildContext context, AppState provider) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: SizedBox(
                height: 400,
                child: CustomPaint(
                  painter: HeaderCurvedContainer(),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    // height: 400,
                  ),
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace,
                                              ) {
                                                return Image.network(
                                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
                                              }),
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
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (
                                                                BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace,
                                                              ) {
                                                                return Image
                                                                    .network(
                                                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
                                                              }),
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
                                                return 'You cannot enter numbers and special characters';
                                              } else if (spaceIndex! > 10) {
                                                setState(() {
                                                  _isInvalid = true;
                                                });
                                                return 'First name must be maximum 10 characters';
                                              } else if ((value.length -
                                                          spaceIndex +
                                                          1) >
                                                      10 ||
                                                  value.length > 21) {
                                                setState(() {
                                                  _isInvalid = true;
                                                });
                                                return 'Last name must be maximum 10 characters';
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
                          pressGeoON
                              ? SizedBox()
                              : Column(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 320,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          print("ddddd");
                                          if (formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _editMode = !_editMode;
                                              pressGeoON = !pressGeoON;
                                            });
                                            CoolAlert.show(
                                              title: "Success",
                                              context: context,
                                              type: CoolAlertType.success,
                                              text:
                                                  "Profile updated successfuly!",
                                              confirmBtnColor:
                                                  const Color(0xff7b39ed),
                                            );

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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: 55,
                                          width: 320,
                                          child: SizedBox(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 216, 58, 47),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                minimumSize: Size(2000000, 15),
                                              ),
                                              onPressed: () async {
                                                deleteacc(context);
                                              },

                                              //  color: Color.fromARGB(255, 240, 96, 86),
                                              child: Text(
                                                'Delete my account',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // child: ElevatedButton(
                                          //   style: ElevatedButton.styleFrom(
                                          //     backgroundColor: Color.fromARGB(
                                          //         255, 216, 58, 47),
                                          //   ),
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       pressGeoON = !pressGeoON;
                                          //       _editMode = !_editMode;
                                          //       _isInvalid = false;
                                          //       //_isInvalid = !_isInvalid;
                                          //       print(_editMode);
                                          //     });
                                          //   },
                                          //   child: const Text(
                                          //     'Delete my account',
                                          //     style: TextStyle(
                                          //       fontSize: 20,
                                          //       color: Colors.white,
                                          //     ),
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                          // buildColumn(provider),
                        ],
                      ),
                    )
                  ],
                ),
              ]), //key for form
            ),
          ],
        ),
        // if (_editMode)
        //   Align(
        //     alignment: Alignment.centerLeft,
        //     child: Text(
        //       ' Today progress',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        //     ),
        //   ),
        SizedBox(height: 1),
        if (_editMode)
          Align(
            heightFactor: 1,
            alignment: Alignment.centerLeft,
            child: Text(
              '  Today\'s progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),

        if (_editMode)
          Card(
            margin: const EdgeInsets.only(left: 11.0, right: 11.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * 0.90,
                        // width: 300.0,
                        lineHeight: 15,
                        /*percent: (provider.myList[index].completedTask) *
                      1.0 /
                      (provider.myList[index].completedTask +
                          provider.myList[index].pendingTask) *
                      1.0,*/
                        animation: true,
                        animationDuration: 2000,
                        linearStrokeCap: LinearStrokeCap.round,
                        percent: getPercentToday(provider)!,
                        // percent: 0.5,
                        progressColor: Color(0xff7b39ed),
                        center: Text(""),
                      ),
                    ),
                  ],
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "You have completed ${provider.numberCompletedToday} tasks of ${(provider.numberProgressToday + provider.numberCompletedToday)}",
                    // "You have ${provider.numberProgressToday} uncompleted tasks left today ",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                )),
              ],
            ),
          ),
        if (_editMode)
          const SizedBox(
            height: 5,
          ),
        if (_editMode)
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 4, left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Achieved so far",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        if (_editMode)
          SizedBox(
            height: 1,
          ),
        if (_editMode) Expanded(child: buildColumnList(provider)),
        if (_editMode)
          SizedBox(
            height: 35,
          ),
      ],
    );
  }

  double? getPercentToday(AppState provider) {
    try {
      if (provider.numberProgressToday + provider.numberCompletedToday != 0) {
        return double.tryParse((provider.numberCompletedToday /
                (provider.numberProgressToday + provider.numberCompletedToday))
            .toString());
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  Widget buildColumnList(AppState provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          provider.listLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.myList.isEmpty
                  ? const Center(
                      child: Text(
                      'There are no lists yet',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ))
                  : ListView.builder(
                      itemCount: provider.myList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = provider.myList[index].docId;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskScreen(
                                            category:
                                                provider.myList[index].category,
                                            list: provider.myList[index].list)))
                                .then((value) {
                              getList();
                              setState(() {});
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.only(
                                      top: 4,
                                      bottom: 4,
                                      left: 11.0,
                                      right: 11.0),
                                  //alignment: Alignment.center,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                provider.myList[index].list,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: LinearPercentIndicator(
                                                  width: 200,
                                                  lineHeight: 10,
                                                  // percent: 0.5,
                                                  percent: getPercentList(
                                                      provider, index)!,
                                                  animation: true,
                                                  animationDuration: 2000,
                                                  linearStrokeCap:
                                                      LinearStrokeCap.round,
                                                  progressColor:
                                                      Color(0xff7b39ed),
                                                  center: Text(""),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "You complete ${provider.myList[index].completedTask} Tasks from ${provider.myList[index].completedTask + provider.myList[index].pendingTask}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
        ],
      ),
    );
  }

  double? getPercentList(AppState provider, int index) {
    try {
      if ((provider.myList[index].completedTask +
              provider.myList[index].pendingTask) !=
          0.0) {
        return double.tryParse(((provider.myList[index].completedTask) *
                1.0 /
                (provider.myList[index].completedTask +
                    provider.myList[index].pendingTask) *
                1.0)
            .toString());
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff7b39ed);
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 175, size.width, 100)
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

Future<void> DeleteUserAccount() async {
  print("inside delete");
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  final currentid = _firebaseAuth.currentUser?.uid;
  print(FirebaseAuth.instance.currentUser!.email);
  print(currentid);
  FirebaseFirestore.instance.collection('users1').doc(currentid).delete();
  await FirebaseAuth.instance.currentUser!.delete();
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      "Yes",
      style: TextStyle(
        fontSize: 15,
      ),
    ),
    onPressed: () async {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    },
  );
  Widget continueButton = TextButton(
    child: Text(
      "No",
      style: TextStyle(
        fontSize: 15,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

deleteacc(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      "Yes",
      style: TextStyle(
        fontSize: 15,
      ),
    ),
    onPressed: () async {
      print("InsideDelete");
      DeleteUserAccount();

      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    },
  );
  Widget continueButton = TextButton(
    child: Text(
      "No",
      style: TextStyle(
        fontSize: 15,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Account"),
    content: Text('Are you sure you want to delete your account?'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
