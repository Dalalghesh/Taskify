import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/Screens/todo_list_screen.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/models/tasks.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/AddTask.dart';

class TaskDetail extends StatefulWidget {
  final Tasksss task;
  final Tasksss taskOld;
  final int index;
  final bool isConpleted;

  TaskDetail(
      {Key? key,
      required this.task,
      required this.index,
      required this.taskOld,
      this.isConpleted = false}) {}

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late Tasksss myTask;
  late Tasksss oldMyTask;
  //DateTime dateTime;
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  @override
  void initState() {
    myTask = widget.task;
    oldMyTask = widget.task;
    // TODO: implement initState
    super.initState();
    // if(widge)
    print("ddd ${widget.isConpleted}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print("ddd ${widget.isConpleted}");
      // Provider.of<AppState>(context, listen: false).updateEditTask(false);
    });

    taskDescriptionController.text = myTask.description;
    taskNameController.text = myTask.task;

    formatDate();
  }

  String dateOnly = "";

  formatDate() {
    if (myTask.deadline.runtimeType == Timestamp) {
      Timestamp timestamp = myTask.deadline;
      DateTime dateTime = timestamp.toDate();
      print(dateTime);
      dateTimeUpdate = dateTime;
      dateOnly = DateFormat('dd/MM/yyyy').format(dateTime);
    } else {
      DateTime convertedDateTime = DateTime.parse(myTask.deadline.toString());
      Timestamp timestamp = Timestamp.fromDate(convertedDateTime);
      DateTime dateTime = timestamp.toDate();
      dateTimeUpdate = dateTime;
      dateOnly = DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  DateTime dateTimeUpdate = DateTime.now();
  DateTime FdateTime = new DateTime.utc(2024, 1, 1);

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: Colors.purple[800],
      shouldCloseDialogAfterCancelTapped: true,
    );
    AppState provider = Provider.of<AppState>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            myTask.task,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff7b39ed),
        ),
        body: buildSingleChildScrollView(context, provider),
        // body: buildSingleChildScrollViewOld(context, provider),
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(
      BuildContext context, AppState provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey,
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Task Details:",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Row(
                      children: [
                        if (!widget.isConpleted)
                          Container(
                            child: IconButton(
                              icon: provider.editTask
                                  ? const Icon(Icons.done)
                                  : const Icon(Icons.edit),
                              onPressed: () async {
                                print("myTask ${widget.taskOld.task}");
                                print("myTask ${myTask.task}");
                                print("myTask ${oldMyTask.task}");
                                // provider.updateEditTask(!provider.editTask);
                                ///
                                if (provider.editTask == true &&
                                    provider.imageLoading == false) {
                                  // await FirebaseFirestore.instance.collection('tasks').doc(myTask.id).update(
                                  //     {
                                  //       'Deadline': dateTimeUpdate,
                                  //       'description': myTask.description,
                                  //       'Image': myTask.image,
                                  //       'Task':myTask.task,
                                  //       'Priority':myTask.priority
                                  //     });
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.confirm,
                                      text: 'Do you want to edit this task?',
                                      confirmBtnText: 'Yes',
                                      cancelBtnText: 'No & Back',
                                      confirmBtnColor: const Color(0xff7b39ed),
                                      title: "Edit",
                                      onCancelBtnTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        // Navigator.of(context).pop();
                                        provider
                                            .updateEditTask(!provider.editTask);
                                      },
                                      onConfirmBtnTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(myTask.id)
                                            .update({
                                          'Deadline': dateTimeUpdate,
                                          'description': myTask.description,
                                          'Image': myTask.image,
                                          'Task': myTask.task,
                                          'Priority': myTask.priority
                                        });
                                        CoolAlert.show(
                                          title: "Success",
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Task Edited successfuly!",
                                          confirmBtnColor:
                                              const Color(0xff7b39ed),
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            provider.updateEditTask(
                                                !provider.editTask);
                                          },
                                        );
                                      });
                                } else {
                                  provider.updateEditTask(!provider.editTask);
                                }
                              },
                            ),
                          ),
                        Container(
                          child: IconButton(
                            icon: const Icon(Icons.delete_rounded),
                            onPressed: () {
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you want to delete this task?',
                                  confirmBtnText: 'Yes',
                                  cancelBtnText: 'No',
                                  confirmBtnColor: const Color(0xff7b39ed),
                                  title: "Delete",
                                  onConfirmBtnTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(myTask.id)
                                        .update({'status': 'deleted'});
                                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> TodoList(category: myTask.category,)), (route) => false);

                                    CoolAlert.show(
                                      title: "Success",
                                      context: context,
                                      type: CoolAlertType.success,
                                      text: "Task Deleted successfuly!",
                                      confirmBtnColor: const Color(0xff7b39ed),
                                      onConfirmBtnTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(width: 6,),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: provider.editTask
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                    )
                                  : BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 19.0, bottom: 19.0, right: 8, left: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    provider.editTask
                                        ? showPriorityDialog(context)
                                            .then((value) => setState(() {}))
                                        : "";
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    // margin: EdgeInsets.only(left: 16),
                                    decoration: BoxDecoration(
                                      color: myTask.priority == 'High'
                                          ? Color.fromARGB(255, 223, 123, 123)
                                          : myTask.priority == 'Medium'
                                              ? Color.fromARGB(
                                                  255, 223, 180, 123)
                                              : Color.fromARGB(
                                                  255, 152, 224, 154),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              //    margin: EdgeInsets.only(left: 16),
                              width: MediaQuery.of(context).size.width / 3,
                              alignment: Alignment.center,

                              child: provider.editTask
                                  ? TextField(
                                      controller: taskNameController,
                                      onChanged: (v) {
                                        myTask.task = v;
                                      },
                                      decoration: InputDecoration(
                                          // border: InputBorder.none,
                                          // focusedBorder: InputBorder.none,
                                          // enabledBorder: InputBorder.none,
                                          // errorBorder: InputBorder.none,
                                          // disabledBorder: InputBorder.none,
                                          ),
                                    )
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(19.0),
                                        child: Text(
                                          myTask.task,
                                          maxLines: 3,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (provider.editTask) {
                              _selectDate();
                            }
                          },
                          child: Container(
                            // provider.editTask
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: provider.editTask
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                  )
                                : BoxDecoration(),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(19.0),
                                child: Text(
                                  "${dateOnly}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (provider.editTask) {
                            String res = await provider.uploadTaskImage();
                            print("response" + res.toString());
                            if (res != '0') {
                              setState(() {
                                myTask.image = res;
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 130,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: provider.imageLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Image.network(
                                  myTask.image,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  //    margin: EdgeInsets.only(left: 16),
                  width: MediaQuery.of(context).size.width / 1.3,

                  child: provider.editTask
                      ? TextField(
                          controller: taskDescriptionController,
                          onChanged: (v) {
                            myTask.description = v;
                          },
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              // focusedBorder: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                              ),
                        )
                      : Text(
                          myTask.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                    onPressed: () {
                      if (!widget.isConpleted) {
                        provider.updateShowSubTasks(
                            !myTask.showSubTasks, widget.index);
                      }
                      if (widget.isConpleted) {
                        setState(() {
                          myTask.showSubTasks = !myTask.showSubTasks;
                        });
                      }
                      // Respond to button press
                    },
                    icon: Icon(Icons.view_list, size: 18),
                    label: myTask.showSubTasks
                        ? Text(
                            "hide subtasks",
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            "view subtasks",
                            textAlign: TextAlign.center,
                          )),
                myTask.showSubTasks
                    ? Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              provider.filteredSubTasks.isEmpty
                                  ? Center(
                                      child: Text('No sub tasks'),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          provider.filteredSubTasks.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            provider.filteredSubTasks[index]
                                                .subTask,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        );
                                      }),
                            ]))
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SingleChildScrollView buildSingleChildScrollViewOld(BuildContext context, AppState provider)  {
  //   return SingleChildScrollView(
  //       child: Column(
  //         children: [
  //
  //           Container(
  //             width: MediaQuery.of(context).size.width,
  //             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             padding: EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     blurRadius: 3,
  //                     color: Colors.grey,
  //                   ),
  //                 ]),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     Container(
  //                       child: IconButton(
  //                         icon:
  //                         provider.editTask ?
  //                         Icon(Icons.done):
  //                         Icon(Icons.edit),
  //                         onPressed: ()async {
  //
  //                           if(provider.editTask== true && provider.imageLoading== false ){
  //                             await FirebaseFirestore.instance.collection('tasks').doc(myTask.id).update(
  //                                 {
  //                                   'Deadline': dateTimeUpdate,
  //                                   'description': myTask.description,
  //                                   'Image': myTask.image,
  //                                   'Task':myTask.task,
  //                                   'Priority':myTask.priority
  //                                 });
  //                           }
  //
  //                           provider.updateEditTask(!provider.editTask);
  //                         },
  //                       ),
  //                     ),
  //                     //SizedBox(width: 6,),
  //                     Container(
  //                       child: IconButton(
  //                         icon: Icon(Icons.delete_rounded),
  //                         onPressed: () {
  //
  //
  //                           CoolAlert.show(
  //                               context: context,
  //                               type: CoolAlertType.confirm,
  //                               text: 'Do you want to delete this task?',
  //                               confirmBtnText: 'Yes',
  //                               cancelBtnText: 'No',
  //                               confirmBtnColor: Color(0xff7b39ed),
  //                               title: "Delete",
  //                               onConfirmBtnTap: () async {
  //                                 await FirebaseFirestore.instance.collection('tasks').doc(myTask.id).update(
  //                                     {
  //                                       'status': 'deleted'
  //                                     });
  //                                 // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> TodoList(category: myTask.category,)), (route) => false);
  //                                 Navigator.of(context).pop();
  //                                 Navigator.of(context).pop();
  //                               });
  //                         },
  //                       ),
  //                     ),
  //
  //                   ],
  //                 ),
  //                 SizedBox(height: 10,),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(
  //                       // provider.editTask
  //
  //                       decoration: provider.editTask ? BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(color: Colors.grey, width: 1),
  //                       ) :BoxDecoration(
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(19.0),
  //                         child: GestureDetector(
  //                           onTap:(){
  //
  //                             provider.editTask?
  //                          showPriorityDialog(context).then((value) => setState((){})) :"" ;
  //                         },
  //                           child: Container(
  //                             height: 20,
  //                             width: 20,
  //                             // margin: EdgeInsets.only(left: 16),
  //                             decoration: BoxDecoration(
  //                               color: myTask.priority == 'High'
  //                                   ? Color.fromARGB(255, 223, 123, 123)
  //                                   : myTask.priority == 'Medium'
  //                                       ? Color.fromARGB(255, 223, 180, 123)
  //                                       : Color.fromARGB(255, 152, 224, 154),
  //                               shape: BoxShape.circle,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       //    margin: EdgeInsets.only(left: 16),
  //                       width: MediaQuery.of(context).size.width/3,
  //                       alignment: Alignment.center,
  //
  //                       child: provider.editTask ?
  //                       TextField(
  //                         controller: taskNameController,
  //                         onChanged: (v) {
  //                           myTask.task = v;
  //                         },
  //                         decoration: InputDecoration(
  //                           // border: InputBorder.none,
  //                           // focusedBorder: InputBorder.none,
  //                           // enabledBorder: InputBorder.none,
  //                           // errorBorder: InputBorder.none,
  //                           // disabledBorder: InputBorder.none,
  //                         ),
  //                       ):
  //                       Text(
  //                         myTask.task,
  //                         maxLines: 3,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: ()async{
  //
  //                         if(provider.editTask) {
  //                           _selectDate();
  //
  //                         }
  //                       },
  //                       child: Container(
  //                         // provider.editTask
  //
  //                         decoration: provider.editTask ? BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           border: Border.all(color: Colors.grey, width: 1),
  //                         ) :BoxDecoration(
  //                         ),
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(19.0),
  //                           child: Text(
  //                             "${dateOnly}",
  //                             style: TextStyle(
  //                               color: Colors.grey.shade700,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 16,),
  //                 GestureDetector(
  //                   onTap:()async{
  //                     if(provider.editTask){
  //                   String res =  await  provider.uploadTaskImage();
  //                   print("response"+res.toString());
  //                   if(res != '0'){
  //
  //                     setState(() {
  //                       myTask.image = res;
  //                     });
  //                   }
  //
  //                     }
  //                   },
  //                   child: Container(
  //                     height: 130,
  //                     width: MediaQuery.of(context).size.width * 0.4,
  //                     child: provider.imageLoading ? Center(
  //                       child: CircularProgressIndicator(),
  //                     ):
  //
  //                     Image.network(myTask.image, fit: BoxFit.cover,),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //             Container(
  //               //    margin: EdgeInsets.only(left: 16),
  //               width: MediaQuery.of(context).size.width/1.3,
  //
  //               child: provider.editTask ?
  //               TextField(
  //                 controller: taskDescriptionController,
  //                 onChanged: (v) {
  //                   myTask.description = v;
  //                 },
  //                 decoration: InputDecoration(
  //                   // border: InputBorder.none,
  //                   // focusedBorder: InputBorder.none,
  //                   // enabledBorder: InputBorder.none,
  //                   // errorBorder: InputBorder.none,
  //                   // disabledBorder: InputBorder.none,
  //                 ),
  //               ):
  //                 Text(
  //                   myTask.description,
  //                   maxLines: 3,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
  //                 )
  //               ,),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 TextButton.icon(
  //                     onPressed: () {
  //                       provider.updateShowSubTasks(!myTask.showSubTasks, widget.index);
  //                       // Respond to button press
  //                     },
  //                     icon: Icon(Icons.view_list, size: 18),
  //                     label:
  //                     myTask.showSubTasks ? Text(
  //                       "hide subtasks",
  //                       textAlign: TextAlign.center,
  //                     ) :
  //                     Text(
  //                       "view subtasks",
  //                       textAlign: TextAlign.center,
  //                     )),
  //                 myTask.showSubTasks? Container(
  //                   margin: EdgeInsets.only(left: 50),
  //                   child:
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       SizedBox(height: 10,),
  //
  //                       provider.filteredSubTasks.isEmpty ? Center(child: Text('No sub tasks'),):
  //                       ListView.builder(
  //                           itemCount: provider.filteredSubTasks.length,
  //                           shrinkWrap: true,
  //                           itemBuilder: (context, index){
  //                             return   Container(
  //                               margin: EdgeInsets.only(bottom: 10),
  //                               child: Text(provider.filteredSubTasks[index].subTask, style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 18,
  //                               ),),
  //                             );
  //                           }),])): Container()
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  // }
  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTimeUpdate,
        firstDate: DateTime(1900),
        lastDate: DateTime(1900),
      );

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate = dateTimeUpdate;
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
                    minimumDate: dateTimeUpdate,
                    initialDateTime: dateTimeUpdate,
                    maximumDate: FdateTime,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        dateTimeUpdate = newDateTime;
                        dateOnly =
                            DateFormat('dd/MM/yyyy').format(dateTimeUpdate);
                      });
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

  showPriorityDialog(context) {
    // AppState provider = Provider.of<AppState>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 14, left: 10, right: 10),
                                    child: Text(
                                      'Priority',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  myTask.priority = 'High';

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            // margin: EdgeInsets.only(left: 16),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 223, 123, 123),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'High',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      myTask.priority == 'High'
                                          ? Icon(Icons.done)
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  myTask.priority = 'Medium';
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            // margin: EdgeInsets.only(left: 16),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 223, 180, 123),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Medium',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      myTask.priority == 'Medium'
                                          ? Icon(Icons.done)
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  myTask.priority = 'Low';
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            // margin: EdgeInsets.only(left: 16),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 152, 224, 154),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Low',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      myTask.priority == 'Low'
                                          ? Icon(Icons.done)
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])),
          );
        });
  }
}
