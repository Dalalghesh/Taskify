import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task_list.dart';

import 'models/tasks.dart';


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
  List<TaskListModel> list = [];
  bool listLoading = true;
  getList(cat)async{
    listLoading = true;
    notifyListeners();
    list.clear();
    print(cat);

    final res = await FirebaseFirestore.instance.collection('List').where('CategoryName', isEqualTo: cat).where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.email).get();
    for(int i = 0; i< res.docs.length; i++){
      TaskListModel task = TaskListModel(
          docId: res.docs[i].id,
          email: res.docs[i]['UID'],
          category: res.docs[i]['CategoryName'],
          list: res.docs[i]['List'],
          private: res.docs[i]['isPrivate']
      );
      list.add(task);
    }
    print(list.length);
    listLoading = false;
    notifyListeners();
  }

    clearTask(){
      tasksList.clear();
      notifyListeners();
    }
 // List<dynamic> tasks = [];
  List< Tasksss> tasksList = [];

  bool tasksLoading = true;
  getTasks(cat, list)async {
    tasksLoading = true;
    notifyListeners();
 //   tasks.clear();
    tasksList.clear();
    print(cat);

    final res = await FirebaseFirestore.instance.collection('tasks').where('CategoryName', isEqualTo: cat).where('ListName', isEqualTo: list).where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.email).where('status', isEqualTo: 'pending').get();
    for(int i = 0; i< res.docs.length; i++){
      Tasksss taskss = Tasksss(id: res.docs[i].id,
          task: res.docs[i]['Task'],
          priority: res.docs[i]['Priority'],
          category: res.docs[i]['CategoryName'],
          list: res.docs[i]['ListName'],
          description: res.docs[i]['description'],
          value: false,
          deadline: res.docs[i]['Deadline']);

      tasksList.add(taskss);

     // tasks.add(res.docs[i]['Task']);
    }
   // print(tasks.length);
    tasksLoading = false;
    notifyListeners();
  }


  List< Tasksss> completedtasksList = [];

  bool completedtasksLoading = true;
  getCompletedTasks(cat, list)async{
    completedtasksLoading = true;
    notifyListeners();
    //   tasks.clear();
    completedtasksList.clear();
    print(cat);

    final res = await FirebaseFirestore.instance.collection('tasks').where('CategoryName', isEqualTo: cat).where('ListName', isEqualTo: list).where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.email).where('status', isEqualTo: 'completed').get();
    for(int i = 0; i< res.docs.length; i++){
      Tasksss taskss = Tasksss(id: res.docs[i].id,
          task: res.docs[i]['Task'],
          priority: res.docs[i]['Priority'],
          category: res.docs[i]['CategoryName'],
          list: res.docs[i]['ListName'],
          description: res.docs[i]['description'],
          value: false,
          deadline: res.docs[i]['Deadline']);
          // deadline: res.docs[i]['Deadline'].toString());

      completedtasksList.add(taskss);

      // tasks.add(res.docs[i]['Task']);
    }
    // print(tasks.length);
    completedtasksLoading = false;
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
      private: res.docs[i]['isPrivate']
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



  updateCheckboxValue(bool v, int index)async{
    tasksList[index].value = v;
    await FirebaseFirestore.instance.collection('tasks').doc(tasksList[index].id).update(
        {
          'status': 'completed'

        });
    completedtasksList.add(tasksList[index]);
    notifyListeners();
    tasksList.removeAt(index);
    notifyListeners();
  }


}
