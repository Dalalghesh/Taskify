import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/invitation/screens/send_invitation.dart';
import 'package:taskify/screens/Add_Category.dart';
import '../homePage.dart';
import 'AddTask.dart';
import 'package:taskify/util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:get/get.dart';
import 'package:taskify/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

////////////////////////////// 257
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AddList());
}

class AddList extends StatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  _AddList createState() => _AddList();
}

///-----------------------------------------
late var userData;
Future<void> getUserData() async {
  var user = FirebaseAuth.instance.currentUser;
  userData = user!.uid;
  //print(userData);
}

///-----------------------------------------

class _AddList extends State<AddList> {
  bool isPrivate = false;
  final CAtegoryNameController = TextEditingController();

  void getCategoryy() async {
    final res = await _firestore
        .collection('users1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    categoriesList = res['categories'];
    if (categoriesList.length == 0)
      CoolAlert.show(
        context: context,
        title: "",
        type: CoolAlertType.error,
        text: "You don't have categories, create category first!",
        confirmBtnColor: const Color(0xff7b39ed),
        onConfirmBtnTap: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Add_Category())),
      );

    print(categoriesList);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    CAtegoryNameController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>(); //key for form
  final _firestore = FirebaseFirestore.instance;
  String Category = '';
  List<dynamic> categoriesList = [];
  TextEditingController categoryController = TextEditingController();
  TextEditingController ListController = TextEditingController();

  var selectCategory;
  bool buttonenabled = false;
  late String u;
  late final String documentId;
  String selectedValue = '';
  bool isChecked = false;
  late String listt;
  late String category;

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context, listen: false);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    getUserData();
    getCategoryy();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add List",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 0, 0, 0),
              //fontWeight: FontWeight.w600,
            ),
          ),
          leadingWidth: 50,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }, // home page
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey, //key for form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Add List',
                  //   style: Theme.of(context).textTheme.headline4,
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/AddList.png",
                        height: 250,
                        width: 250,
                      )),
                  SizedBox(
                    height: 16,
                  ),

                  //-----------------------List name-----------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'List Name:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                      maxLength: 15,
                      keyboardType: TextInputType.text,
                      controller: ListController,
                      decoration: InputDecoration(
                        hintText: 'Assignments',
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
                          return "Please enter a name";
                        else if (!regExp.hasMatch(value.trim())) {
                          return 'You cannot enter special characters !@#\%^&*()';
                        } else
                          return null;
                      },
                      onChanged: (value) async {
                        listt = value;
                      },
                      style: Theme.of(context).textTheme.subtitle1),
                  //-----------------------End of list name-----------------------

                  SizedBox(
                    height: 8,
                  ),

                  //-----------------------Categorey-----------------------

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'Categorey:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),

                  SizedBox(
                    height: 3,
                  ),

                  DropdownButtonFormField2<String>(
                      buttonHeight: 18,
                      scrollbarAlwaysShow: true,
                      itemHeight: 35,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
                      items: provider.categories.map((value) {
                        return DropdownMenuItem(
                          value: value.toString(),
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                      onChanged: (categoreyValue) {
                        setState(() {
                          selectCategory = categoreyValue;
                        });
                      },
                      validator: (value) {
                        if (value == null)
                          return "Please choose category";
                        else
                          return null;
                      },
                      value: selectCategory,
                      isExpanded: true,
                      hint: new Text("Choose category",
                          style: TextStyle(fontSize: 15))),

                  //-----------------------End of Categorey-----------------------

                  CheckboxListTile(
                      activeColor: Color(0xff7b39ed),
                      //checkColor: Color(0xff7b39ed),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text("Do you want it to be shared?"),
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                        print(isChecked);
                        // How did value change to true at this point?
                      }),

                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () async {
                          //navigate to check email view
                          if (formKey.currentState!.validate()) {
                            final snackBar =
                                SnackBar(content: Text("Added successfully"));
                            print(listt);
                            print(selectCategory);
                            var listId;

                            await FirebaseFirestore.instance
                                .collection('List')
                                .add({
                              'CategoryName': selectCategory,
                              'List': listt,
                              'UID': [FirebaseAuth.instance.currentUser!.email],
                              'isPrivate': isChecked ? false : true,
                            }).then((value) => listId = value.id);
                            ListController.clear();

                            isChecked?
                            await FirebaseFirestore.instance
                                .collection('chat-groups').doc(listId).set({
                              'list': listt,
                              'users':FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]) ,
                              'chatId':listId,
                              'date': DateTime.now(),
                            }): '';

                            CoolAlert.show(
                              title: "Success",
                              context: context,
                              type: CoolAlertType.success,
                              text: "List Added successfuly!",
                              confirmBtnColor: const Color(0xff7b39ed),
                              onConfirmBtnTap: () => route(isChecked, listId),
                            );
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

  void route(bool? isChecked, id) {
    if (isChecked == true)
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SendInvitation(
                  category: selectCategory, list: listt, listId: id)));
    //Util.routeToWidget(context, SendInvitation()); ///////////
    else
      Util.routeToWidget(context, NavBar(tabs: 0));

    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => AddTask()));

    // Util.routeToWidget(context, AddTask());
    //print(text);
  }

  Widget _buildButton(
      {VoidCallback? onTap, required String text, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MaterialButton(
        color: color,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
