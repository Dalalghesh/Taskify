import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskify/models/tasks.dart';

class TaskDetails extends StatelessWidget {
  final String id;
  final String category;
  final String list;
  final String priority;
  final Timestamp deadline;
  final String description;
  final String task;
  final bool value;
  const TaskDetails({
    Key? key,
    required this.id,
    required this.category,
    required this.list,
    required this.priority,
    required this.deadline,
    required this.description,
    required this.task,
    required this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            task,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(children: [
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
                        color: this.priority == 'High'
                            ? Color.fromARGB(255, 223, 123, 123)
                            : this.priority == 'Medium'
                                ? Color.fromARGB(255, 223, 180, 123)
                                : Color.fromARGB(255, 152, 224, 154),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      this.task,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        //  color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                     child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 10, color: Colors.black38),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        margin: const EdgeInsets.all(4),
        child: Image.asset('images/pic$imageIndex.jpg'),
      ),
    );

Widget _buildImageRow(int imageIndex) => Row(
      children: [
        _buildDecoratedImage(imageIndex),
        _buildDecoratedImage(imageIndex + 1),
      ],
    );

                    /*Text(
                      tasks.deadline,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),*/

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
                    this.description,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  ),
                ),
              ],
            ),
          )
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
                        color: this.priority == 'High'
                            ? Color.fromARGB(255, 223, 123, 123)
                            : this.priority == 'Medium'
                                ? Color.fromARGB(255, 223, 180, 123)
                                : Color.fromARGB(255, 152, 224, 154),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      this.task,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        //  color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.left,
                    ),

        ]));
  }
}
