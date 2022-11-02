import 'package:cloud_firestore/cloud_firestore.dart';

class TasksModel {
  static List<Tasksss> tasks = [];
}

class Tasksss {
  String id;
  String image;
  String category;
  String list;
  String priority;
  var deadline;
  String description;
  String status;
  String task;
  bool value;
  bool showSubTasks;
  bool showAssignedMembers;
  List<dynamic> assignedMembers;
  bool manage;

  Tasksss({
    required this.image,
    required this.id,
    required this.priority,
    required this.category,
    required this.list,
    required this.description,
    required this.deadline,
    required this.task,
    required this.value,
    required this.status,
    required this.showSubTasks,
    required this.showAssignedMembers,
    required this.assignedMembers,
    required this.manage,
  });
}

class AssignedMembers {
  String userId;
  String userName;
  bool value;

  AssignedMembers(
      {required this.value, required this.userName, required this.userId});
}
