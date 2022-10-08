import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/models/tasks.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';

class TaskDetail extends StatelessWidget {
  final Tasksss task;
  const TaskDetail({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateOnly = "";
    if (task.deadline.runtimeType == Timestamp) {
      Timestamp timestamp = task.deadline;
      DateTime dateTime = timestamp.toDate();
      dateOnly = DateFormat('dd/MM/yyyy').format(dateTime);
    } else {
      DateTime convertedDateTime = DateTime.parse(task.deadline.toString());
      Timestamp timestamp = Timestamp.fromDate(convertedDateTime);
      DateTime dateTime = timestamp.toDate();
      dateOnly = DateFormat('dd/MM/yyyy').format(dateTime);
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            task.task,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff7b39ed),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete_rounded),
              onPressed: () {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.confirm,
                    text: 'Do you want to delete this task?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: Color(0xff7b39ed),
                    title: "Delete",
                    onConfirmBtnTap: () async {});
              },
            ),
          ]),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
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
                    Container(
                      height: 20,
                      width: 20,
                      // margin: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        color: task.priority == 'High'
                            ? Color.fromARGB(255, 223, 123, 123)
                            : task.priority == 'Medium'
                                ? Color.fromARGB(255, 223, 180, 123)
                                : Color.fromARGB(255, 152, 224, 154),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      task.task,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        //  color: Colors.grey.shade700,
                      ),
                      //  textAlign: TextAlign.left,
                    ),
                    Text(
                      "${dateOnly}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  //    margin: EdgeInsets.only(left: 16),

                  child: Text(
                    task.description,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  ),
                ),
                SizedBox(height: 15),
                TextButton.icon(
                    onPressed: () {
                      // Respond to button press
                    },
                    icon: Icon(Icons.comment, size: 18),
                    label: Text(
                      "view comments",
                      textAlign: TextAlign.center,
                    )),
                TextButton.icon(
                    onPressed: () {
                      // Respond to button press
                    },
                    icon: Icon(Icons.view_list, size: 18),
                    label: Text(
                      "view subtasks",
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
          Container(
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Color(0xff7b39ed),
              foregroundColor: Colors.white,
              onPressed: () => {},
            ),
            alignment: Alignment(-0.8, -1),
          )
        ],
      ),
    );
  }
}
