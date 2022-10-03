import 'package:cloud_firestore/cloud_firestore.dart';

class TasksModel {
  static List<Tasksss> tasks = [];
}

class Tasksss {
  String id;
  String category;
  String list;
  String priority;
  var deadline;
  String description;
  String task;
  bool value;

  Tasksss({
    required this.id,
    required this.priority,
    required this.category,
    required this.list,
    required this.description,
    required this.deadline,
    required this.task,
    required this.value,
  });
}
