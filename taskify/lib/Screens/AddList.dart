import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:taskify/Screens/AddTask.dart';
import 'package:taskify/Screens/InviteFriend.dart';
import 'package:taskify/util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';

void main() async {
  //Initializing Database when starting the application.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AddList());
}

Widget build(BuildContext context) {
  return MaterialApp(
    home: AddList(),
  );
}

class AddList extends StatefulWidget {
  @override
  _AddList createState() => _AddList();
}

class _AddList extends State<AddList> {
  var selectCategory;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //const SendInstructionsView({Key? key}) : super(key: key);
  final _firestore = FirebaseFirestore.instance;
  //final formKey = GlobalKey<FormState>(); //key for form
  bool buttonenabled = false;
  late final String documentId;

  //final dropdownlist = <String>['Home', 'University', 'Work', 'Grocery'];
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    bool? isChecked = false;

    late String listt;
    late String category;
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {}, // home page
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create List',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/AddList.png",
                      height: 200,
                      width: 200,
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
                    decoration: InputDecoration(
                      hintText: 'Ex: SWE444',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Please enter a name";
                      else
                        return null;
                    },
                    onChanged: (value) {
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
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('cat').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      Text("Loading");
                    } else {
                      List<DropdownMenuItem> Categories = [];
                      for (int i = 0;
                          i < (snapshot.data! as QuerySnapshot).docs.length;
                          i++) {
                        DocumentSnapshot ds = snapshot.data!.docs[i];
                        Categories.add(
                          DropdownMenuItem(
                            child: Text(ds.id),
                            value: "${ds.id}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: DropdownButtonFormField2<dynamic>(
                                scrollbarAlwaysShow: true,
                                itemHeight: 35,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                items: Categories,
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
                          ),
                        ],
                      );
                    }
                    return Text("");
                  },
                ),

                CheckboxListTile(
                    activeColor: Color(0xff7b39ed),
                    checkColor: Color(0xff7b39ed),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text("Do you want it to be shared?"),
                    value: isChecked,
                    onChanged: (bool? value) {
                      isChecked = value;
                      print(isChecked);
                      // How did value change to true at this point?
                    }),

                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        //navigate to check email view
                        if (formKey.currentState!.validate()) {
                          final snackBar =
                              SnackBar(content: Text("Created successfully"));
                          print(listt);
                          print(selectCategory);
                          _firestore.collection('List').add({
                            'Category': selectCategory,
                            'Name': listt,
                          });
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "List created successfuly!",
                            confirmBtnColor: const Color(0xff7b39ed),
                            onConfirmBtnTap: () => route(isChecked),
                          );
                        }
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void route(bool? isChecked) {
    if (isChecked == true)
      Util.routeToWidget(context, InviteFriend());
    else
      Util.routeToWidget(context, AddTask());
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
