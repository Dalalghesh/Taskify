import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskify/Screens/AddList.dart';
import 'package:taskify/Screens/InviteFriend.dart';
import 'package:taskify/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  //Initializing Database when starting the application.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AddTask());
}

Widget build(BuildContext context) {
  return MaterialApp(
    home: AddTask(),
  );
}

class AddTask extends StatefulWidget {
  @override
  _AddTask createState() => _AddTask();
}

class _AddTask extends State<AddTask> {
  var selectedList;
  final _firestore = FirebaseFirestore.instance;
  late String taskk;
  var priority;
  var description;
  DateTime dateTime = new DateTime.now();
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  final formKey = GlobalKey<FormState>(); //key for form
  late DateTime selectedDateTime;
  bool pressed = false;
  bool buttonenabled = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: 40,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Util.routeToWidget(context, InviteFriend());
            },
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
                Text(
                  'Add Task',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 0,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/AddTasks.png",
                      height: 250,
                      width: 250,
                    )),
                SizedBox(
                  height: 10,
                ),

                //-----------------------List name-----------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Task Name:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex: Assignment',
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
                      setState(() {
                        taskk = value;
                      });
                      print(taskk);
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
                    'List:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('List1')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var doc = snapshot.data?.docs;

                      List<DropdownMenuItem> Listss = [];
                      for (int i = 0;
                          i < (snapshot.data! as QuerySnapshot).docs.length;
                          i++) {
                        //bERJgJI288LgROb1gUN3
                        DocumentSnapshot ds = snapshot.data!.docs[i];
                        Listss.add(
                          DropdownMenuItem(
                            child: Text(ds.get('List_Id')),
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
                                items: Listss,
                                onChanged: (categoreyValue) {
                                  setState(() {
                                    selectedList = categoreyValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null)
                                    return "Please choose list";
                                  else
                                    return null;
                                },
                                value: selectedList,
                                isExpanded: true,
                                hint: new Text("Choose list",
                                    style: TextStyle(fontSize: 15))),
                          ),
                        ],
                      );
                    }
                    return Text("");
                  },
                ),
                //-----------------------End of Categorey-----------------------
                SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Priority:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Container(
                  child: DropdownButtonFormField(
                      //style
                      decoration: InputDecoration(
                          hintText: 'Home',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          )),
                      isExpanded: true,
                      hint: Text('Choose priority',
                          style: TextStyle(fontSize: 15)),
                      //style

                      items:
                          <String>['High', 'Medium', 'Low'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          priority = value;
                        });
                        print(priority);
                      },
                      validator: (value) {
                        if (value == null)
                          return "Please choose priority";
                        else
                          return null;
                      }),
                ),

                SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Deadline:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                _DatePickerItem(
                  children: <Widget>[
                    CupertinoButton(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      disabledColor: CupertinoColors.quaternarySystemFill,

                      // Display a CupertinoDatePicker in dateTime picker mode.
                      onPressed: () => _showDialog(
                        CupertinoDatePicker(
                          minimumDate: dateTime,
                          initialDateTime: dateTime,
                          use24hFormat: false,
                          // This is called when the user changes the dateTime.
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() => dateTime = newDateTime);
                          },
                        ),
                      ),

                      child: Text(
                        '            ${dateTime.month}/${dateTime.day}/${dateTime.year}                  ${dateTime.hour}:${dateTime.minute}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Task description:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      // hintText: 'Ex: Assignment',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Please enter a description";
                      else
                        return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                      print(description);
                    },
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(
                  height: 15,
                ),

                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final snackBar =
                              SnackBar(content: Text("Created successfully"));
                          _firestore.collection("Task1").doc().set({
                            'TaskID': taskk,
                            'CategoryName': '',
                            'ListID': 't1',
                            'deadline': dateTime,
                            'isDone': false,
                            'priority': priority,
                            'Description': description,
                            'uID': 'ZfITEhTBOmayoUpqp1ohgGoqmTe2',
                          });
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "List created successfuly!",
                            confirmBtnColor: const Color(0xff7b39ed),
                            onConfirmBtnTap: () => route(),
                          );
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(50, 40),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          primary: Colors.grey.shade600,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          //home pagee
                          Util.routeToWidget(context, InviteFriend());
                        },
                        child: const Text('Later'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(1900),
        //helpText: 'Choose deadline',
      );

  void route() {
    //route it to home page
    Util.routeToWidget(context, AddList());
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

// This class simply decorates a row of widgets.
class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    OutlinedButton.styleFrom(
      side: BorderSide(color: Color(0xff7b39ed)),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.5,
          ),
          left: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.5,
          ),
          right: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
