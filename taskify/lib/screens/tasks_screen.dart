import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taskify/Screens/TaskDetails.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:intl/intl.dart';
import 'package:taskify/utils/app_colors.dart';
import '../controller/UserController.dart';
import '../models/sub_tasks.dart';
import '../models/tasks.dart';
import 'Task_Detail.dart';
import 'dart:convert';
import 'package:taskify/service/local_push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:taskify/models/users.dart';

class TaskScreen extends StatefulWidget {
  static String id = "Taskscompleted";
  List<dynamic> UIDS = [];
  final String category;
  final String list;

  TaskScreen({Key? key, required this.category, required this.list})
      : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTask();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    FirebaseMessaging.instance.subscribeToTopic('subscription');
  }

  getTask() async {
    print(widget.category);
    await Future.delayed(Duration(milliseconds: 100));
    // Provider.of<AppState>(context, listen: false).updateShowSubTasks(false);
    Provider.of<AppState>(context, listen: false).clearTask();

    Provider.of<AppState>(context, listen: false)
        .getTasks(widget.category, widget.list);
    Provider.of<AppState>(context, listen: false)
        .getCompletedTasks(widget.category, widget.list);
    Provider.of<AppState>(context, listen: false).getSubTasks();
  }

  TextEditingController subTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    // TODO: implement build

    return buildColumnNew(context, provider);
  }

  // Column buildColumnOld(BuildContext context, AppState provider) {
  //   return Column(
  //     children: [
  //       Container(
  //         height: MediaQuery.of(context).size.height / 2.5,
  //         child: provider.tasksLoading
  //             ? Center(
  //                 child: CircularProgressIndicator(),
  //               )
  //             : provider.tasksList.isEmpty
  //                 ? Center(
  //                     child: Text(
  //                     'List is empty',
  //                     style: TextStyle(color: Colors.black, fontSize: 18),
  //                   ))
  //                 : ListView.builder(
  //                     itemCount: provider.tasksList.length,
  //                     shrinkWrap: true,
  //                     itemBuilder: (context, index) {
  //                       return Container(
  //                         height: 50,
  //                         width: MediaQuery.of(context).size.width,
  //                         margin: EdgeInsets.only(
  //                             left: 20, right: 20, top: 5, bottom: 5),
  //                         decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             // boxShadow: [
  //                             //   BoxShadow(
  //                             //     color: Colors.grey,
  //                             //     blurRadius: 3,
  //                             //   )
  //                             // ],
  //                             borderRadius: BorderRadius.circular(8)),
  //                         //alignment: Alignment.center,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Container(
  //                               height: 20,
  //                               width: 20,
  //                               margin: EdgeInsets.only(left: 16),
  //                               decoration: BoxDecoration(
  //                                 color: provider.tasksList[index].priority ==
  //                                         'High'
  //                                     ? Color.fromARGB(255, 223, 123, 123)
  //                                     : provider.tasksList[index].priority ==
  //                                             'Medium'
  //                                         ? Color.fromARGB(255, 223, 180, 123)
  //                                         : Color.fromARGB(255, 152, 224, 154),
  //                                 shape: BoxShape.circle,
  //                               ),
  //                             ),
  //                             Text(
  //                               provider.tasksList[index].task,
  //                               textAlign: TextAlign.left,
  //                             ),
  //                             Checkbox(
  //                                 value: provider.tasksList[index].value,
  //                                 onChanged: (v) {
  //                                   provider.updateCheckboxValue(v!, index);
  //                                 })
  //                           ],
  //                         ),
  //                       );
  //                     }),
  //       ),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Text(
  //         'Completed',
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //       ),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Container(
  //         height: MediaQuery.of(context).size.height / 2.5,
  //         child: provider.completedtasksLoading
  //             ? Center(
  //                 child: CircularProgressIndicator(),
  //               )
  //             : provider.completedtasksList.isEmpty
  //                 ? Center(
  //                     child: Text(
  //                     'List is empty',
  //                     style: TextStyle(color: Colors.black, fontSize: 18),
  //                   ))
  //                 : ListView.builder(
  //                     itemCount: provider.completedtasksList.length,
  //                     shrinkWrap: true,
  //                     itemBuilder: (context, index) {
  //                       return Container(
  //                         height: 50,
  //                         width: MediaQuery.of(context).size.width,
  //                         margin: EdgeInsets.only(
  //                             left: 20, right: 20, top: 5, bottom: 5),
  //                         decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             // boxShadow: [
  //                             //   BoxShadow(
  //                             //     color: Colors.grey,
  //                             //     blurRadius: 3,
  //                             //   )
  //                             // ],
  //                             borderRadius: BorderRadius.circular(8)),
  //                         //alignment: Alignment.center,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Container(
  //                               height: 20,
  //                               width: 20,
  //                               margin: EdgeInsets.only(left: 16),
  //                               decoration: BoxDecoration(
  //                                 color: provider.completedtasksList[index]
  //                                             .priority ==
  //                                         'High'
  //                                     ? Color.fromARGB(255, 223, 123, 123)
  //                                     : provider.completedtasksList[index]
  //                                                 .priority ==
  //                                             'Medium'
  //                                         ? Color.fromARGB(255, 223, 180, 123)
  //                                         : Color.fromARGB(255, 152, 224, 154),
  //                                 shape: BoxShape.circle,
  //                               ),
  //                             ),
  //                             Text(
  //                               provider.completedtasksList[index].task,
  //                               textAlign: TextAlign.left,
  //                             ),
  //                             Container(),
  //
  //                             // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
  //                             //   provider.updateCheckboxValue(v!, index);
  //                             // })
  //                           ],
  //                         ),
  //                       );
  //                     }),
  //       ),
  //     ],
  //   );
  // }

  List<TasksCn> tasks = [];

  Widget buildColumnNew(BuildContext context, AppState provider) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
              PopupMenuButton<int>(
                color: Colors.white,
                itemBuilder: (context) => [
                  // popupmenu item 1
                  const PopupMenuItem(
                    value: 1,
                    // row has two child icon and text.
                    child: Text("Sort By Deadline"),
                  ),
                  // popupmenu item 2
                  const PopupMenuItem(
                    value: 2,
                    // row has two child icon and text
                    child: Text("Sort By priority"),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    /// dead line
                    setState(() {
                      sortDeadLine(provider);
                    });
                  } else if (value == 2) {
                    /// Propriety
                    sortPropriety(provider);
                    sortProprietyCompleted(provider);
                  }
                },
                offset: const Offset(0, 50),
                elevation: 2,
                child: const Padding(
                  padding: EdgeInsets.only(right: 12.0, left: 12),
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.filter_list),
              //   onPressed: () {},
              //   color: Colors.white,
              // )
            ],
          ),
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
                                              provider.fiterSubTask(provider
                                                  .tasksList[index].task);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskDetail(
                                                            task: provider
                                                                    .tasksList[
                                                                index],
                                                            taskOld: provider
                                                                    .tasksList[
                                                                index],
                                                            index: index,
                                                          ))).then((value) {
                                                setState(() {
                                                  getTask();
                                                  // getTaskWithoutClear();
                                                });
                                              });
                                            },
                                            child: Container(
                                              //height: 65,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: const EdgeInsets.only(
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
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 30,
                                                        child: IconButton(
                                                          icon: Icon(provider
                                                                  .tasksList[
                                                                      index]
                                                                  .showSubTasks
                                                              ? Icons
                                                                  .arrow_drop_down
                                                              : Icons
                                                                  .arrow_right),
                                                          iconSize: 35,
                                                          onPressed: () {
                                                            provider
                                                                .updateAddNewTaskValue(
                                                                    false);
                                                            provider.fiterSubTask(
                                                                provider
                                                                    .tasksList[
                                                                        index]
                                                                    .task);
                                                            provider.updateShowSubTasks(
                                                                !provider
                                                                    .tasksList[
                                                                        index]
                                                                    .showSubTasks,
                                                                index);
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                        margin: EdgeInsets.only(
                                                            left: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: provider
                                                                      .tasksList[
                                                                          index]
                                                                      .priority ==
                                                                  'High'
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  223,
                                                                  123,
                                                                  123)
                                                              : provider
                                                                          .tasksList[
                                                                              index]
                                                                          .priority ==
                                                                      'Medium'
                                                                  ? Color
                                                                      .fromARGB(
                                                                          255,
                                                                          223,
                                                                          180,
                                                                          123)
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          152,
                                                                          224,
                                                                          154),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            provider
                                                                .tasksList[
                                                                    index]
                                                                .task,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          Text(
                                                            '${dateOnly} ${isAfterDeadLine ? " - ${timeAgo(dateTime)}" : ""}',
                                                            style: TextStyle(
                                                              color:
                                                                  isAfterDeadLine
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black,
                                                              fontWeight:
                                                                  isAfterDeadLine
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .normal,
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
                                                                  .tasksList[
                                                                      index]
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
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  provider.tasksList[index]
                                                          .showSubTasks
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 50),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              ListView.builder(
                                                                  itemCount: provider
                                                                      .filteredSubTasks
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        "${index + 1} -  ${provider.filteredSubTasks[index].subTask}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              provider.addNewSubTask
                                                                  ? Container(
                                                                      height:
                                                                          40,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2,
                                                                      //  padding: EdgeInsets.only(bottom: 10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            subTaskController,
                                                                        onChanged:
                                                                            (v) {
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        decoration: InputDecoration(
                                                                            // border: InputBorder.none,
                                                                            ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              provider.addNewSubTask
                                                                  ? SizedBox(
                                                                      height:
                                                                          10,
                                                                    )
                                                                  : Container(),
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      provider.updateAddNewTaskValue(
                                                                          true);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      width:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            0,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              blurRadius: 3,
                                                                              color: Color.fromARGB(0, 158, 158, 158)),
                                                                        ],
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            100,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Color(0xff7b39ed),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          'Add Subtask',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  provider.addNewSubTask
                                                                      ? SizedBox(
                                                                          width:
                                                                              10,
                                                                        )
                                                                      : Container(),
                                                                  provider.addNewSubTask
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            if (subTaskController.text.length >
                                                                                2) {
                                                                              SubTasks task = SubTasks(id: '', uid: FirebaseAuth.instance.currentUser!.email.toString(), task: provider.tasksList[index].task, subTask: subTaskController.text);

                                                                              provider.subTasks.add(task);
                                                                              provider.fiterSubTask(provider.tasksList[index].task);
                                                                              provider.updateAddNewTaskValue(false);
                                                                              await FirebaseFirestore.instance.collection('sub-tasks').add({
                                                                                'SubTask': subTaskController.text,
                                                                                'Task': provider.tasksList[index].task,
                                                                                'UID': FirebaseAuth.instance.currentUser!.email,
                                                                              });
                                                                              subTaskController.clear();
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                100,
                                                                            decoration:
                                                                                BoxDecoration(color: subTaskController.text.length < 3 ? Colors.grey : Color(0xff7b39ed), borderRadius: BorderRadius.circular(10)),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Text(
                                                                              'Save',
                                                                              style: TextStyle(color: Colors.white, fontSize: 15),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container()
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
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
                                                        onConfirmBtnTap:
                                                            () async {
                                                          getUsers(
                                                              widget.category,
                                                              widget.list);
                                                          tasks.forEach(
                                                              (element) {
                                                            provider.updateCheckboxValue(
                                                                element.second!,
                                                                tasks.indexOf(
                                                                    element));
                                                          });
                                                          tasks.clear();
                                                          provider.tasksList
                                                              .forEach(
                                                                  (element) {
                                                            element.value =
                                                                false;
                                                          });

                                                          await getTask();
                                                          setState(() {});
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
                                    Timestamp timestamp = provider
                                        .completedtasksList[index].deadline;
                                    DateTime dateTime = timestamp.toDate();

                                    String dateOnly = DateFormat('dd/MM/yyyy')
                                        .format(dateTime);
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigator.pop(context);
                                        provider.fiterSubTask(provider
                                            .completedtasksList[index].task);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskDetail(
                                                      // TaskDetails(
                                                      index: index,
                                                      isConpleted: true,
                                                      task: provider
                                                              .completedtasksList[
                                                          index],
                                                      taskOld: provider
                                                              .completedtasksList[
                                                          index],
                                                    )));
                                      },
                                      child: Container(
                                        // height: 50,
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
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 30,
                                                  child: IconButton(
                                                    icon: Icon(provider
                                                            .completedtasksList[
                                                                index]
                                                            .showSubTasks
                                                        ? Icons.arrow_drop_down
                                                        : Icons.arrow_right),
                                                    iconSize: 35,
                                                    onPressed: () {
                                                      provider
                                                          .updateAddNewTaskValue(
                                                              false);
                                                      provider.fiterSubTask(
                                                          provider
                                                              .completedtasksList[
                                                                  index]
                                                              .task);
                                                      provider.updateShowCompletedSubTasks(
                                                          !provider
                                                              .completedtasksList[
                                                                  index]
                                                              .showSubTasks,
                                                          index);
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  margin:
                                                      EdgeInsets.only(left: 16),
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
                                                Text(
                                                  provider
                                                      .completedtasksList[index]
                                                      .task,
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  '${dateOnly}',
                                                ),
                                                Container(),

                                                // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
                                                //   provider.updateCheckboxValue(v!, index);
                                                // })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            provider.completedtasksList[index]
                                                    .showSubTasks
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 70),
                                                    child: provider
                                                                .filteredSubTasks
                                                                .length !=
                                                            0
                                                        ? ListView.builder(
                                                            itemCount: provider
                                                                .filteredSubTasks
                                                                .length,
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child: Text(
                                                                  "${index + 1} -  ${provider.filteredSubTasks[index].subTask}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              );
                                                            })
                                                        : Text('No sub tasks'),
                                                  )
                                                : Container(),
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

  void sortDeadLine(AppState provider) {
    provider.tasksList
        .sort((Tasksss a, Tasksss b) => a.deadline.compareTo(b.deadline));
    provider.completedtasksList
        .sort((Tasksss a, Tasksss b) => a.deadline.compareTo(b.deadline));
  }

  void sortPropriety(AppState provider) {
    // provider.tasksList.sort((Tasksss a,Tasksss b) => a.id.compareTo(b.id));
    List<Tasksss> tempTask = provider.tasksList;
    List<Tasksss> tempTask_L = [];
    List<Tasksss> tempTask_M = [];
    List<Tasksss> tempTask_H = [];
    tempTask.forEach((element) {
      if (element.priority == "Low") {
        tempTask_L.add(element);
      } else if (element.priority == "Medium") {
        tempTask_M.add(element);
      } else if (element.priority == "High") {
        tempTask_H.add(element);
      }
    });
    tempTask.clear();
    tempTask.addAll(tempTask_H);
    tempTask.addAll(tempTask_M);
    tempTask.addAll(tempTask_L);

    // provider.tasksList.clear() ;
    setState(() {
      provider.tasksList = tempTask;
    });
  }

  void sortProprietyCompleted(AppState provider) {
    // provider.tasksList.sort((Tasksss a,Tasksss b) => a.id.compareTo(b.id));
    List<Tasksss> tempTask = provider.completedtasksList;
    List<Tasksss> tempTask_L = [];
    List<Tasksss> tempTask_M = [];
    List<Tasksss> tempTask_H = [];
    tempTask.forEach((element) {
      if (element.priority == "Low") {
        tempTask_L.add(element);
      } else if (element.priority == "Medium") {
        tempTask_M.add(element);
      } else if (element.priority == "High") {
        tempTask_H.add(element);
      }
    });
    tempTask.clear();
    tempTask.addAll(tempTask_H);
    tempTask.addAll(tempTask_M);
    tempTask.addAll(tempTask_L);

    // provider.tasksList.clear() ;
    setState(() {
      provider.completedtasksList = tempTask;
    });
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

sendNotification(String title, String token) async {
  print(token);
  print('dalal');
  print('raghad');

  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };

  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAArqJFQfk:APA91bFyFdlX-dk-72NHyaoN0hb4xsp8wuDUhr63ZgI7vroxRSBX1mXbd2pASgdzoYKA_8A0ZYRw61GzRaIH_6eakiVtyr_X8FJrlax-HwJdSUzbk022EGjfVjkDo7dlgYZNXaMfJS4T'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{
                'title': title,
                'body': 'Your friend has completed some tasks!'
              },
              'priority': 'high',
              'data': data,
              'to': '$token'
            }));

    if (response.statusCode == 200) {
      print("Yeh notificatin is sended");
    } else {
      print("Error");
    }
  } catch (e) {}
}

getUsers(String CategoryName, String ListName) async {
  print('1');
  List<dynamic> UIDS = [];
  final _firebaseFirestore = FirebaseFirestore.instance;
  print(CategoryName);
  print(ListName);
  final res = await _firebaseFirestore
      .collection('List')
      .where("CategoryName", isEqualTo: CategoryName)
      .where("List", isEqualTo: ListName)
      .get();

  print('after bring collection');
  if (res.docs.isNotEmpty) {
    for (int i = 0; i < res.docs.length; i++) {
      if (res.docs[i]['List'] == ListName) {
        UIDS = res.docs[i]['UID'];
        for (int i = 0; i < UIDS.length; i++) {
          print('Inside loop+i');
          final String useremail = UIDS[i];
          print(useremail);
          getUsersToken(useremail);
        }
      }
    }
  }
}

Future getUsersToken(String receiver) async {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  print(receiver);
  print('hello');
  final currentUserEmail = _firebaseAuth.currentUser?.email;
  final sendEmail = '';
  print('hello2');
  final res = await _firebaseFirestore
      .collection('users1')
      .where("email", isEqualTo: receiver)
      .get();
  print('hello3');
  if (res.docs.isNotEmpty) {
    for (int i = 0; i < res.docs.length; i++) {
      if (res.docs[i]['email'] == receiver) {
        print('dalll');
        // print(res.docs[i]['token']);
        print('alll');
        final String receivertoken = res.docs[i]['token'];
        sendNotification('New task completed', receivertoken);
      }
    }
  }
}
