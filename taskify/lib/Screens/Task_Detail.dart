import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskify/models/tasks.dart';
import 'package:intl/intl.dart';

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
      ),
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

                    // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
                    //   provider.updateCheckboxValue(v!, index);
                    // })
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
