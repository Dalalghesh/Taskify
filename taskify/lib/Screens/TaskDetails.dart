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
      body: Column(
        children: [
          Container(
            child: Text(
              priority,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                //  color: Colors.grey.shade700,
              ),
              //  textAlign: TextAlign.left,
            ),
          ),
          Container(
            child: Text(
              deadline.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                //  color: Colors.grey.shade700,
              ),
              //  textAlign: TextAlign.left,
            ),
          ),
          Container(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                //  color: Colors.grey.shade700,
              ),
              //  textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
