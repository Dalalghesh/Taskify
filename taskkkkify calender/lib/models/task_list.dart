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