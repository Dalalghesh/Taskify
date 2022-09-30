import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/models/task_list.dart';
import 'package:taskify/utils/validators.dart';
import 'AddList.dart';
// import 'package:taskify/Screens/InviteFriend.dart';
import 'package:taskify/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:taskify/firebase_options.dart';
import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  //Initializing Database when starting the application.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(AddTask());
}

// Widget build(BuildContext context) {
//   return MaterialApp(
//     home: AddTask(),
//   );
// }

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTask createState() => _AddTask();
}

late var userData;
Future<void> getUserData() async {
  var user = FirebaseAuth.instance.currentUser;
  userData = user!.uid;
  //print(userData);
}

class _AddTask extends State<AddTask> {
  var selectCategory1;
  var selectCategory;


  String Category = '';
  List<TaskListModel> lList = [];
  String? c;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getlists();

    });
    super.initState();
  }

  // TextEditingController categoryController = TextEditingController();
  void getlists() async {
    print('hi');
    lList=  await Provider.of<AppState>(context, listen: false).getListForTask();
   // lList = Provider.of<AppState>(context, listen: false).taskList;
   // lList = res['lists'];
    if (lList.isEmpty) {
      print('GG');
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "You don't have lists, create list first!",
        confirmBtnColor: const Color(0xff7b39ed),
        onConfirmBtnTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AddList())),
      );
    }

    print(lList);
  }

  int myVar = 1;
  var selectedList;
  final _firestore = FirebaseFirestore.instance;
  late String taskk;
  var priority;
  String? docid;
  var description;
  DateTime dateTime = new DateTime.now();
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 250,
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
    AppState provider = Provider.of<AppState>(context, listen: true);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leadingWidth: 40,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Util.routeToWidget(context, NavBar(tabs: 0));
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
            )
          ],
        ),
        body: provider.taskListLoading ?
            Center(child: CircularProgressIndicator(),):
        SingleChildScrollView(
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
                      hintText: 'At least 3 characters',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value == null || value.trim() == '')
                        return "Please enter Category name";
                       else if (value.length <= 2) {
                        return "Please enter at least 2 characters";
                      }
                      return null;
                    },
                    onChanged: (value) {
                    //  setState(() async {
                        taskk = value;
                    //  });
                      print(taskk);
                    },
                    style: Theme.of(context).textTheme.subtitle1),

                //-----------------------End of list name-----------------------

                SizedBox(
                  height: 8,
                ),
                //-----------------------list-----------------------

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Category:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                DropdownButtonFormField2<String>(
                    scrollbarAlwaysShow: true,
                    itemHeight: 35,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
                    items:  provider.categories
                    .map((value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                    onChanged: (categoreyValue) {

                      setState(() {
                        selectCategory1 = categoreyValue;
                      });
                      print(selectCategory1);
                      provider.filterList(selectCategory1);
                    },
                    validator: (value) {
                      if (value == null)
                        return "Please choose category";
                      else
                        return null;
                    },
                    value: selectCategory1,
                    isExpanded: true,
                    hint: new Text("Choose category",
                        style: TextStyle(fontSize: 15))),
                SizedBox(
                  height: 8,
                ),
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

                DropdownButtonFormField2<String>(
                    scrollbarAlwaysShow: true,
                    itemHeight: 35,

                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
                    items: provider.taskList
                        .map(( value) {
                      return DropdownMenuItem<String>(
                        value: value.list.toString(),
                        child: Text(
                          value.list,
                        ),
                      );
                    }).toList(),
                    onChanged: provider.disableDropDown ? null:
                        (value) {
                    //  print('doc12343'+value.());
                      setState(() {
                        docid = value;
                        selectCategory = value;


                      });
                   },
                    validator: (value) {
                      if (value == null)
                        return "Please choose list";
                      else
                        return null;
                    },
                    value: selectCategory,
                    isExpanded: true,
                    hint: new Text("Choose list",
                        style: TextStyle(fontSize: 15))),

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
                  child: AnimatedRadioButtons(
                    backgroundColor: Color.fromARGB(0, 255, 238, 88),
                    value: myVar,
                    layoutAxis: Axis.horizontal,
                    buttonRadius: 16.0,
                    items: [
                      AnimatedRadioButtonItem(
                          label: "High",
                          labelTextStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          color: Color.fromARGB(255, 223, 123, 123),
                          fillInColor: Color.fromARGB(255, 243, 207, 207)),
                      AnimatedRadioButtonItem(
                          label: "Medium",
                          labelTextStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          color: Color.fromARGB(255, 223, 180, 123),
                          fillInColor: Color.fromARGB(255, 238, 211, 153)),
                      AnimatedRadioButtonItem(
                          label: "Low",
                          labelTextStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          color: Color.fromARGB(255, 152, 224, 154),
                          fillInColor: Color.fromARGB(255, 213, 241, 228))
                    ],
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        myVar = value;
                      });
                    },
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Deadline: (optionally)',
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
                        '            ${dateTime.month}/${dateTime.day}/${dateTime.year}   -   ${dateTime.hour}:${dateTime.minute}',
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
                    minLines: 1,
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
                      onPressed: ()async {
                        if (formKey.currentState!.validate()) {
                          await FirebaseFirestore.instance.collection('tasks').add({
                            'CategoryName': selectCategory1,
                            'UID': FirebaseAuth.instance.currentUser!.email,
                            'Task': taskk,
                            'ListName': docid,
                            'Priority': myVar == 0 ? 'High' : myVar == 1 ? 'Medium': 'Low',
                            'Deadline': dateTime,
                            'description': description,
                            'status': 'pending',

                          });


                          final snackBar =
                              SnackBar(content: Text("Created successfully"));

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
                  height: 20,
                ),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Util.routeToWidget(context, NavBar(tabs: 0));
                    },
                    child: const Text('Later'),

                  ),

                ),
                SizedBox(
                  height: 20,
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child: TextButton(
                //         style: TextButton.styleFrom(
                //           minimumSize: Size(50, 40),
                //           padding: EdgeInsets.zero,
                //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           primary: Colors.grey.shade600,
                //           textStyle: const TextStyle(fontSize: 18),
                //         ),
                //         onPressed: () {
                //           //home pagee
                //           Util.routeToWidget(context, AddList());
                //         },
                //         child: const Text('Later'),
                //       ),
                //     ),
                //   ],
                // ),
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
    Util.routeToWidget(context, NavBar(tabs: 0));
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

  // validate(value) {
  //   if (value == null)
  //     return "Please choose priority";
  //   else
  //     return null;
  // }
}
