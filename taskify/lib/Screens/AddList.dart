import 'dart:html';

import 'package:flutter/material.dart';
import 'package:taskify/Screens/AddTask.dart';
import 'package:taskify/Screens/InviteFriend.dart';
import 'package:taskify/util.dart';

void main() {
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
  //const SendInstructionsView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>(); //key for form
  String name = "";
  bool buttonenabled = false;

  //final dropdownlist = <String>['Home', 'University', 'Work', 'Grocery'];
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    bool? isChecked = false;
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
                      "/Users/raghad/Desktop/Taskify/taskify/assets/AddList.png",
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
                  height: 5,
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

                Container(
                  child: DropdownButtonFormField(
                      //style
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      )),

                      //style: Theme.of(context).inputDecorationTheme.border,
                      // focusColor: Color.fromARGB(255, 69, 31, 156),
                      //  borderRadius: BorderRadius.circular(25),
                      isExpanded: true,
                      hint: Text('Choose category',
                          style: TextStyle(fontSize: 15)),
                      //style

                      items: <String>['Home', 'University', 'Work', 'Grocery']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null)
                          return "Please choose category";
                        else
                          return null;
                      }),
                ),
                //-----------------------End of Categorey-----------------------

                SizedBox(
                  height: 8,
                ),

                CheckboxListTile(
                  activeColor: Color(0xff7b39ed),
                  checkColor: Color(0xff7b39ed),
                  title: Text("Do you want it to be shared?"),
                  value: isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked = newValue;
                    });
                  },
                ),

                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        //navigate to check email view
                        if (formKey.currentState!.validate()) {
                          final snackBar =
                              SnackBar(content: Text("Created successfully"));
                          Util.routeToWidget(context, InviteFriend());
                          _scaffoldKey.currentState!.showSnackBar(snackBar);
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
}
