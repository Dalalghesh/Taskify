import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taskify/Screens/TaskDetails.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:intl/intl.dart';
import '../controller/UserController.dart';
import 'Task_Detail.dart';

class TaskScreen extends StatefulWidget {
  final String category;
  final String list;

  TaskScreen({
    Key? key,
    required this.category,
    required this.list,
  }) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppState>(context, listen: false).clearTask();
    getTask();
  }

  getTask() async {
    print(widget.category);
    await Future.delayed(Duration(milliseconds: 100));

    Provider.of<AppState>(context, listen: false)
        .getTasks(widget.category, widget.list);
    Provider.of<AppState>(context, listen: false)
        .getCompletedTasks(widget.category, widget.list);
  }

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    // TODO: implement build

    return buildColumnNew(context, provider);
  }

  List<TasksCn> tasks = [];

  Widget buildColumnNew(BuildContext context, AppState provider) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                widget.list,
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
              ),
              centerTitle: true,
              backgroundColor: Color(0xff7b39ed),
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    
                  },
                ),
              ]),
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: AppBar(
                  // foregroundColor: Colors.red,
                  backgroundColor: Color(0xff7b39ed),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            // height: 100,
                            decoration: BoxDecoration(
                              //  border: Border.all(width: 1),
                              shape: BoxShape.rectangle,
                              // You can use like this way or like the below line
                              borderRadius: new BorderRadius.circular(10.0),
                              color: Color(0xff7b39ed),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: const Text("Pending")),
                            )),
                      ),
                      Tab(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            // height: 100,
                            decoration: BoxDecoration(
                              //  border: Border.all(width: 1),
                              shape: BoxShape.rectangle,
                              // You can use like this way or like the below line
                              borderRadius: new BorderRadius.circular(10.0),
                              color: Color(0xff7b39ed),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: const Text("Completed")),
                            )),
                      ),
                    ],
                  ),
                ),
              ),

              // create widgets for each tab bar here
              Expanded(
                child: TabBarView(
                  children: [
                    /// Pending
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: provider.tasksLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : provider.tasksList.isEmpty
                              ? Center(
                                  child: Text(
                                  'There are no pending tasks yet',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ))
                              : Column(
                                  children: [
                                    ListView.builder(
                                        itemCount: provider.tasksList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          Timestamp timestamp = provider
                                              .tasksList[index].deadline;
                                          DateTime dateTime =
                                              timestamp.toDate();
                                          bool isAfterDeadLine =
                                              DateTime.now().isAfter(dateTime);
                                          String dateOnly =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(dateTime);

                                          /// It will be only return date DD/MM/YYYY format
                                          return GestureDetector(
                                            onTap: () {
                                              // Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskDetail(
                                                            task: provider
                                                                    .tasksList[
                                                                index],
                                                          )));
                                            },
                                            child: Container(
                                              height: 65,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 5,
                                                  bottom: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // boxShadow: const [
                                                  //   BoxShadow(
                                                  //     color: Colors.grey,
                                                  //     blurRadius: 3,
                                                  //   )
                                                  // ],
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              //alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 20,
                                                    margin: EdgeInsets.only(
                                                        left: 16),
                                                    decoration: BoxDecoration(
                                                      color: provider
                                                                  .tasksList[
                                                                      index]
                                                                  .priority ==
                                                              'High'
                                                          ? Color.fromARGB(255,
                                                              223, 123, 123)
                                                          : provider
                                                                      .tasksList[
                                                                          index]
                                                                      .priority ==
                                                                  'Medium'
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  223,
                                                                  180,
                                                                  123)
                                                              : Color.fromARGB(
                                                                  255,
                                                                  152,
                                                                  224,
                                                                  154),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        provider
                                                            .tasksList[index]
                                                            .task,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        '${dateOnly} ${isAfterDeadLine ? " - ${timeAgo(dateTime)}" : ""}',
                                                        style: TextStyle(
                                                          color: isAfterDeadLine
                                                              ? Colors.red
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Checkbox(
                                                      value: provider
                                                          .tasksList[index]
                                                          .value,
                                                      onChanged: (v) {
                                                        // provider.updateCheckboxValue(v!, index);
                                                        setState(() {
                                                          provider
                                                              .tasksList[index]
                                                              .value = v!;
                                                        });
                                                        if (v! == true) {
                                                          tasks.add(TasksCn(
                                                              index, v));
                                                        } else {
                                                          tasks.removeWhere(
                                                              (element) =>
                                                                  element
                                                                      .first ==
                                                                  index);
                                                        }

                                                        print(tasks.length);
                                                        print(v!);
                                                      })
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20.0, left: 20.0),
                                      child: MaterialButton(
                                        color: tasks.length > 0
                                            ? Color(0xff7b39ed)
                                            : Colors.grey,
                                        minWidth: double.infinity,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        onPressed: tasks.length > 0
                                            ? () {
                                                CoolAlert.show(
                                                  title: "Complete",
                                                  context: context,
                                                  type: CoolAlertType.confirm,
                                                  text:
                                                      'Do you want to mark selected tasks as completed?',
                                                  confirmBtnText: 'Yes',
                                                  cancelBtnText: 'No',
                                                  onCancelBtnTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  onConfirmBtnTap: () {
                                                    CoolAlert.show(
                                                        title: "Successful",
                                                        context: context,
                                                        type: CoolAlertType
                                                            .success,
                                                        text:
                                                            "Task maked as completed successfully!",
                                                        confirmBtnColor:
                                                            const Color(
                                                                0xff7b39ed),
                                                        onConfirmBtnTap: () {
                                                          tasks.forEach(
                                                              (element) {
                                                            provider.updateCheckboxValue(
                                                                element.second!,
                                                                tasks.indexOf(
                                                                    element));
                                                          });
                                                          tasks.clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                  },
                                                  confirmBtnColor:
                                                      Color(0xff7b39ed),
                                                );

                                                // tasks.forEach((element) {
                                                //   provider.updateCheckboxValue(element.second!, element.first);
                                                // });
                                                // provider.updateCheckboxValue(v!, index);
                                              }
                                            : () {},
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Text(
                                            'Mark as completed',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                    ),

                    /// Completed
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: provider.completedtasksLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : provider.completedtasksList.isEmpty
                              ? Center(
                                  child: Text(
                                  'There are no completed tasks yet',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ))
                              : ListView.builder(
                                  itemCount: provider.completedtasksList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskDetails(
                                                      task: provider
                                                              .completedtasksList[
                                                          index],
                                                    )));
                                      },
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 5,
                                            bottom: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: Colors.grey,
                                            //     blurRadius: 3,
                                            //   )
                                            // ],
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        //alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 20,
                                              margin: EdgeInsets.only(left: 16),
                                              decoration: BoxDecoration(
                                                color: provider
                                                            .completedtasksList[
                                                                index]
                                                            .priority ==
                                                        'High'
                                                    ? Color.fromARGB(
                                                        255, 223, 123, 123)
                                                    : provider
                                                                .completedtasksList[
                                                                    index]
                                                                .priority ==
                                                            'Medium'
                                                        ? Color.fromARGB(
                                                            255, 223, 180, 123)
                                                        : Color.fromARGB(
                                                            255, 152, 224, 154),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              provider.completedtasksList[index]
                                                  .task,
                                              textAlign: TextAlign.left,
                                            ),
<<<<<<< Updated upstream:taskify/lib/Screens/tasks_screen.dart
=======
                                            Text(
                                              '${dateOnly}',
                                            ),

>>>>>>> Stashed changes:taskify/lib/screens/tasks_screen.dart
                                            Container(),

                                            // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
                                            //   provider.updateCheckboxValue(v!, index);
                                            // })
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} Late !";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} Late !";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} Late !";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} Late !";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} Late !";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} Late !";
    return "Just Now";
  }
}

class TasksCn {
  int first;
  bool? second;
  TasksCn(this.first, this.second);
}