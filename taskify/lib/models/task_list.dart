class TaskListModel {
  String docId;
  List<dynamic> email;
  String category;
  String list;
  bool private;
  TaskListModel({
    required this.docId,
    required this.email,
    required this.list,
    required this.category,
    required this.private,
  });
}
class TaskListModelProfile {
  String docId;
  int completedTask ;
  int pendingTask ;
  List<dynamic> email;
  String category;
  String list;
  bool private;
  TaskListModelProfile({
    required this.docId,
    required this.email,
     this.pendingTask = 0,
    required this.list,
     this.completedTask = 0,
    required this.category,
    required this.private,
  });
}
