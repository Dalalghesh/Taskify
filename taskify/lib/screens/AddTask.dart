import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/models/task_list.dart';
import 'package:taskify/utils/app_colors.dart';
import 'package:taskify/utils/validators.dart';
import 'AddList.dart';
import 'package:taskify/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:taskify/firebase_options.dart';
import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: Color(0xff7b39ed),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true)
      ]);

  runApp(AddTask());
}

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTask createState() => _AddTask();
}

late var userData;
Future<void> getUserData() async {
  var user = FirebaseAuth.instance.currentUser;
  userData = user!.uid;
}

class _AddTask extends State<AddTask> {
  var selectCategory1;
  var selectCategory;

  // String Category = '';
  List<TaskListModel> lList = [];
  // String? c;

  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).url =
        "https://www.srilankafoundation.org/wp-content/uploads/2020/12/dummy11-1.jpg";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getlists();
    });
    super.initState();
  }

  void getlists() async {
    lList =
        await Provider.of<AppState>(context, listen: false).getListForTask();

    if (lList.isEmpty) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "You don't have lists, create list first!",
        confirmBtnColor: const Color(0xff7b39ed),
        title: "Ooops",
        onConfirmBtnTap: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AddList())),
      );
    }

    // print(lList);
  }

  int myVar = 1;
  // var selectedList;
  // final _firestore = FirebaseFirestore.instance;
  late String taskk;
  // var priority;
  String? docid;
  var description;
  DateTime dateTime = new DateTime.now();
  DateTime FdateTime = new DateTime.utc(2024, 1, 1);
  final formKey = GlobalKey<FormState>(); //key for form
  late DateTime selectedDateTime;
  bool pressed = false;
  bool buttonenabled = false;

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context, listen: true);
    // provider.url =  "https://www.srilankafoundation.org/wp-content/uploads/2020/12/dummy11-1.jpg" ;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    var imageLink =
        'https://www.srilankafoundation.org/wp-content/uploads/2020/12/dummy11-1.jpg';

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xff7b39ed),
          centerTitle: true,
          title: Text(
            "Add Task",
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 255, 255, 255),
              //fontWeight: FontWeight.w600,
            ),
          ),
          leadingWidth: 40,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
            )
          ],
        ),
        body: provider.taskListLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Add Task',
                      //   style: Theme.of(context).textTheme.headline4,
                      // ),
                      SizedBox(
                        height: 2,
                      ),
                      // Align(
                      //     alignment: Alignment.center,
                      //     child: Image.asset(
                      //       "assets/AddTasks.png",
                      //       height: 250,
                      //       width: 250,
                      //     )),

                      Text(
                        'Add picture:',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      GestureDetector(
                        onTap: () {
                          provider.uploadTaskImage();
                        },
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(120),
                                    child: Image.network(
                                      provider.url,

                                      /// "https://www.srilankafoundation.org/wp-content/uploads/2020/12/dummy11-1.jpg"
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Positioned(
                                  bottom: 2,
                                  right: 10,
                                  child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        color: AppColors.deepPurple,

                                        // width: 2

                                        // )
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      )))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //picture

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          'Task Name:',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                          maxLength: 15,
                          decoration: InputDecoration(
                            hintText: 'At least 3 characters',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                          ),
                          validator: (value) {
                            final regExp = RegExp(r'^[a-zA-Z ]+$');

                            if (value!.isEmpty ||
                                value == null ||
                                value.trim() == '')
                              return "Please enter task name";
                            else if (!regExp.hasMatch(value.trim())) {
                              return 'You cannot enter special characters !@#\%^&*()=+';
                            } else if (value.length <= 2) {
                              return "Please enter at least 3 characters";
                            }

                            return null;
                          },
                          onChanged: (value) {
                            taskk = value;
                          },
                          style: Theme.of(context).textTheme.subtitle1),

                      SizedBox(
                        height: 8,
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          'Category:',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          'List:',
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
                          items: provider.filteredtaskList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value.docId,
                              child: Text(
                                value.list,
                              ),
                            );
                          }).toList(),
                          onChanged: provider.disableDropDown
                              ? null
                              : (value) {
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                                labelTextStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                color: Color.fromARGB(255, 223, 123, 123),
                                fillInColor:
                                    Color.fromARGB(255, 250, 170, 170)),
                            AnimatedRadioButtonItem(
                                label: "Medium",
                                labelTextStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),
                                color: Color.fromARGB(255, 223, 180, 123),
                                fillInColor:
                                    Color.fromARGB(255, 238, 211, 153)),
                            AnimatedRadioButtonItem(
                                label: "Low",
                                labelTextStyle: TextStyle(
                                    color: Colors.black, fontSize: 15),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                            onPressed: () => _selectDate(),
                            child: Text(
                              '            ${dateTime.day}/${dateTime.month}/${dateTime.year}   -   ${dateTime.hour}:${dateTime.minute}',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(
                          'Task description:',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                          maxLength: 150,
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
                            // final regExp = RegExp(r'^[a-zA-Z0-9]+$');

                            if (value!.isEmpty ||
                                value == null ||
                                value.trim() == '')
                              return "Please enter a description";
                            // else if (!regExp.hasMatch(value.trim())) {
                            //   return 'You cannot enter special characters !@#\%^&*()';
                            //  }
                            else if (value.length <= 2)
                              return "Please enter at least 3 characters";

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
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final ress = await FirebaseFirestore.instance
                                    .collection('List')
                                    .doc(docid)
                                    .get();
                                List<dynamic> emails = [];
                                String listName;
                                emails = ress['UID'];
                                listName = ress['List'];

                                await FirebaseFirestore.instance
                                    .collection('tasks')
                                    .add({
                                  'CategoryName': selectCategory1,
                                  'UID': emails,
                                  'Task': taskk,
                                  'Image': provider.url,
                                  'ListName': listName,
                                  'Priority': myVar == 0
                                      ? 'High'
                                      : myVar == 1
                                          ? 'Medium'
                                          : 'Low',
                                  'Deadline': dateTime,
                                  'description': description,
                                  'status': 'pending',
                                });

                                final snackBar = SnackBar(
                                    content: Text("Created successfully"));
                                provider.url =
                                    "https://www.srilankafoundation.org/wp-content/uploads/2020/12/dummy11-1.jpg";

                                //call deadline notifaiction
                                print(taskk);
                                Notify(taskk, dateTime);

                                CoolAlert.show(
                                  title: "Success",
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Task created successfuly!",
                                  confirmBtnColor: const Color(0xff7b39ed),
                                  onConfirmBtnTap: () => route(),
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
                      SizedBox(
                        height: 2,
                      ),

                      SizedBox(
                        height: 300,
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
      );

  void route() {
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

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 250,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate = dateTime;
        return Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    minimumDate: dateTime,
                    initialDateTime: dateTime,
                    maximumDate: FdateTime,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() => dateTime = newDateTime);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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

void Notify(String Taskname, DateTime TaskdateTime) async {
  String timezom = await AwesomeNotifications()
      .getLocalTimeZoneIdentifier(); //get time zone you are in

  print("inside notfiy method");
  print(Taskname);
  print(TaskdateTime);
  DateTime currentdate = DateTime.now();
  print(currentdate);
  print('dalal1');
  final differenceday = TaskdateTime.difference(currentdate).inDays;
  final differeneHours = TaskdateTime.difference(currentdate).inHours;
  final differeneMen = TaskdateTime.difference(currentdate).inMinutes;
  final differenceONSECONDS = TaskdateTime.difference(currentdate).inSeconds;
  print(differenceday);
  print(differeneHours);
  print(differeneMen);
  print(differenceONSECONDS);
  print('dalal2');
  ////
  int interval = 5;
  if (differenceONSECONDS > 86340) {
    interval = differenceONSECONDS - 86360;
  }
  print(interval);
  ////
  /* int differenceOnDay =  daysBetween(currentdate, TaskdateTime) -1 ;

  int differenceONSECONDS= 86400 * differenceOnDay;
  
  
   if (differenceONSECONDS ==0 ){
    differenceONSECONDS =5;
   }
   //print(differenceONSECONDS);*/

  if (1438 <= differeneMen) {
    print("inside if");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'Reminder for task deadline',
          body: 'One day left to reach "$Taskname" task deadline!'),
      schedule: NotificationInterval(
          interval: interval, timeZone: timezom, repeats: false),
    );
  }

  /*AwesomeNotifications().actionStream.listen((receivedNotifiction)
{
                  Navigator.of(context).pushNamed(
                    '/navigationPage',
                  );
});*/
}

int daysBetween(DateTime from, DateTime to) {
  print("inside daysbetween");
  Duration diff = to.difference(from);
  print(diff.inDays);
  print(diff.inHours);

  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);

  print("daysBetween");
  print((to.difference(from).inHours / 24).round());
  return (to.difference(from).inHours / 24).round();
}
