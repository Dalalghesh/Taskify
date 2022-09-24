import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task_list.dart';


class AppState extends ChangeNotifier{
  List<dynamic> categories = [];
  bool categoriesLoading = true;

  getCategories()async{
    categoriesLoading = true;
    final res = await FirebaseFirestore.instance.collection('users1').doc(FirebaseAuth.instance.currentUser!.uid).get();
    categories = res['categories'];
    categoriesLoading = false;
    notifyListeners();
  }
  List<dynamic> list = [];
  bool listLoading = true;
  getList(cat)async{
    list.clear();
    print(cat);
    listLoading = true;
    notifyListeners();
    final res = await FirebaseFirestore.instance.collection('List').where('CategoryName', isEqualTo: cat).where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.email).get();
    for(int i = 0; i< res.docs.length; i++){
      list.add(res.docs[i]['List']);
    }
    print(list.length);
    listLoading = false;
    notifyListeners();
  }


  List<dynamic> tasks = [];
  bool tasksLoading = true;
  getTasks(cat, list)async{
    tasks.clear();
    print(cat);
    tasksLoading = true;
    notifyListeners();
    final res = await FirebaseFirestore.instance.collection('tasks').where('CategoryName', isEqualTo: cat).where('ListName', isEqualTo: list).where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.email).get();
    for(int i = 0; i< res.docs.length; i++){
      tasks.add(res.docs[i]['Task']);
    }
    print(tasks.length);
    tasksLoading = false;
    notifyListeners();
  }


  /*==========================================================================================*/

bool taskListLoading = false;
List<TaskListModel> taskList = [];

getListForTask()async{
  taskList.clear();
  taskListLoading = true;
  notifyListeners();
  final res = await FirebaseFirestore.instance.collection('List').where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.email).get();
  for(int i =0; i< res.docs.length; i++){
    TaskListModel task = TaskListModel(
      docId: res.docs[i].id,
      email: res.docs[i]['UID'],
      category: res.docs[i]['CategoryName'],
      list: res.docs[i]['List'],
    );



    taskList.add(task);
  }
  taskListLoading = false;
  notifyListeners();

  return taskList;
}


/*==========================================================================================*/
bool disableDropDown = true;
  List<TaskListModel> filteredtaskList = [];

  filterList(category){
    print(taskList.length);
    disableDropDown = true;
    notifyListeners();
    filteredtaskList =  taskList.where((element) => element.category == category).toList();
    if(filteredtaskList.isNotEmpty){
      disableDropDown = false;
    }
    print(filteredtaskList.length);

    notifyListeners();

  }


}
