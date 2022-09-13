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
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AddList());
}

class AddList extends StatefulWidget {
  @override
  _AddList createState() => _AddList();
}

class _AddList extends State<AddList> {
  var selectCategory;
  // late bool UNIQUE;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  bool buttonenabled = false;
  late final String documentId;
  String selectedValue = '';
  bool? isChecked = false;
  late String listt;
  late String category;
  static var userId = 'ZfITEhTBOmayoUpqp1ohgGoqmTe2';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Util.routeToWidget(context, AddTask());
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
                    onChanged: (value) async {
                      listt = value;
                      // UNIQUE = await isDuplicateName(listt);
                      // if (UNIQUE == false) {
                      //   print(UNIQUE);
                      // } else
                      //   print('object');
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
                  stream: FirebaseFirestore.instance
                      .collection('users1')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      Text("Loading");
                    } else {
                      List<DropdownMenuItem> Categories = [];
                      DocumentSnapshot ds = snapshot.data!.docs[2];
                      dynamic x = ds.get('categories');
                      for (String item in x) {
                        //  print(item);
                        Categories.add(
                          DropdownMenuItem(
                            child: Text(item),
                            value: "${item}",
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

                //-----------------------End of Categorey-----------------------

                CheckboxListTile(
                    activeColor: Color(0xff7b39ed),
                    //checkColor: Color(0xff7b39ed),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text("Do you want it to be shared?"),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value;
                      });
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
                          if (isChecked == true)
                            _firestore.collection("List1").doc().set({
                              'List_Id': listt,
                              'CategoryName': selectCategory,
                              'isPrivate': isChecked,
                              'Members': [],
                              'uID': 'ZfITEhTBOmayoUpqp1ohgGoqmTe2',
                            });
                          if (isChecked == false)
                            _firestore.collection("List1").doc().set({
                              'List_Id': listt,
                              'CategoryName': selectCategory,
                              'isPrivate': isChecked,
                              'uID': 'ZfITEhTBOmayoUpqp1ohgGoqmTe2',
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

  // Future<bool> isDuplicateName(String uniqueName) async {
  //   QuerySnapshot query = await FirebaseFirestore.instance
  //       .collection('List1')
  //       .where('CategoryName', isEqualTo: uniqueName)
  //       .get();
  //   return query.docs.isNotEmpty;
  // }
}
