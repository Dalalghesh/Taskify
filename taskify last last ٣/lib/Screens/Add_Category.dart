import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:taskify/widgets/extensions.dart';
import 'package:taskify/widgets/icons.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';

import '../homePage.dart';
import '../util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Add_Category());
}

Widget build(BuildContext context) {
  return MaterialApp(
    home: Add_Category(),
  );
}

class Add_Category extends StatefulWidget {
  @override
  _Add_Category createState() => _Add_Category();
}

class _Add_Category extends State<Add_Category> {
  final formKey = GlobalKey<FormState>(); //key for form
  final _firestore = FirebaseFirestore.instance;
  String Category = '';
  List<dynamic> categoriesList = [];
  TextEditingController categoryController = TextEditingController();

  void getCategory() async {
    final res = await _firestore
        .collection('users1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    categoriesList = res['categories'];
    print(categoriesList);
  }

  void createCategory() async {
    await _firestore
        .collection('users1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'categories': FieldValue.arrayUnion([Category])
    }, SetOptions(merge: true));
  }

  void initState() {
    super.initState();
    getCategory();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      print('FCM ,Message received');
    });
  }

  final chipIndex = 0.obs;
  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  @override
  final icons = getIcons();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Util.routeToWidget(context, NavBar(tabs: 0));
            }, // home page
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey, //key for form
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Category',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/Category.png',
                        height: 200,
                        width: 200,
                      )),
                  SizedBox(
                    height: 16,
                  ),

                  //-----------------------Category name-----------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'Category Name:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                      maxLength: 15,
                      textCapitalization: TextCapitalization.words,
                      controller: categoryController,
                      onChanged: (value) {
                        Category = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Work',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                      ),
                      validator: (value) {
                        final regExp = RegExp(r'^[a-zA-Z0-9 ]+$');

                        if (value!.isEmpty ||
                            value == null ||
                            value.trim() == '')
                          return "Please enter category name";
                        else if (!regExp.hasMatch(value.trim())) {
                          return 'You cannot enter special characters !@#\%^&*()';
                        } else if (categoriesList.contains(value))
                          return "This category already exist";
                        else
                          return null;
                      },
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(
                    height: 8,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                  //   child: Wrap(
                  //     spacing: 2.0.wp,
                  //     children: icons
                  //         .map((e) => Obx(() {
                  //               final index = icons.indexOf(e);
                  //               return ChoiceChip(
                  //                 label: e,
                  //                 selectedColor: Colors.grey[200],
                  //                 pressElevation: 0,
                  //                 backgroundColor: Colors.white,
                  //                 selected: chipIndex.value == index,
                  //                 onSelected: (bool selected) {
                  //                   chipIndex.value = selected ? index : 0;
                  //                 },
                  //               );
                  //             }))
                  //         .toList(),
                  //   ),
                  // ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          //navigate to check email view
                          if (formKey.currentState!.validate()) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              title: "Success",
                              text: "Created successfully",
                              confirmBtnColor: const Color(0xff7b39ed),
                              // onConfirmBtnTap: () => route(isChecked),
                            );
                            createCategory();
                            categoriesList.add(Category);
                            categoryController.clear();
                            ///////////////////////////////////
                            Util.routeToWidget(context, NavBar(tabs: 0));
                            ///////////////////////////////////

                          }
                        },
                        child: Text(
                          'ADD',
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void route() {
    //route it to home page
    Util.routeToWidget(context, NavBar(tabs: 0));
  }
}
