import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/sub_tasks.dart';
import 'package:taskify/models/task_list.dart';

import 'models/tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppState extends ChangeNotifier {
  List<dynamic> categories = [];
  bool categoriesLoading = true;

  clearTask() {
    taskList.clear();
    notifyListeners();
  }

  getCategories() async {
    categoriesLoading = true;
    final res = await FirebaseFirestore.instance
        .collection('users1')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    categories = res['categories'];
    categoriesLoading = false;
    notifyListeners();
  }

  List<TaskListModel> list = [];
  bool listLoading = true;
  getList(cat) async {
    listLoading = true;
    notifyListeners();
    list.clear();
    print(cat);

    final res = await FirebaseFirestore.instance
        .collection('List')
        .where('CategoryName', isEqualTo: cat)
        .where('UID', arrayContains: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (int i = 0; i < res.docs.length; i++) {
      TaskListModel task = TaskListModel(
          docId: res.docs[i].id,
          email: res.docs[i]['UID'],
          category: res.docs[i]['CategoryName'],
          list: res.docs[i]['List'],
          private: res.docs[i]['isPrivate']);
      list.add(task);
    }
    print(list.length);
    listLoading = false;
    notifyListeners();
  }

  // List<dynamic> tasks = [];
  List<Tasksss> tasksList = [];

  bool tasksLoading = true;
  getTasks(cat, list) async {
    tasksLoading = true;
    notifyListeners();
    //   tasks.clear();
    tasksList.clear();
    print(cat);

    final res = await FirebaseFirestore.instance
        .collection('tasks')
        .where('CategoryName', isEqualTo: cat)
        .where('ListName', isEqualTo: list)
        .where('UID', arrayContains: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo: 'pending')
        .get();
    for (int i = 0; i < res.docs.length; i++) {
      try {
        Tasksss taskss = Tasksss(
            id: res.docs[i].id,
            image: res.docs[i]['Image'],
            task: res.docs[i]['Task'],
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            list: res.docs[i]['ListName'],
            description: res.docs[i]['description'],
            value: false,
            status: res.docs[i]['status'],
            showSubTasks: false,
            deadline: res.docs[i]['Deadline']);

        tasksList.add(taskss);
      } catch (e) {
        Tasksss taskss = Tasksss(
            id: res.docs[i].id,
            status: res.docs[i]['status'],
            image: "",
            task: res.docs[i]['Task'],
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            list: res.docs[i]['ListName'],
            description: res.docs[i]['description'],
            value: false,
            showSubTasks: false,
            deadline: res.docs[i]['Deadline']);

        tasksList.add(taskss);
      }

      // tasks.add(res.docs[i]['Task']);
    }
    tasksList.sort((Tasksss a, Tasksss b) => a.deadline.compareTo(b.deadline));

    // print(tasks.length);
    tasksLoading = false;
    notifyListeners();
  }

  List<Tasksss> completedtasksList = [];

  bool completedtasksLoading = true;
  getCompletedTasks(cat, list) async {
    completedtasksLoading = true;
    notifyListeners();
    //   tasks.clear();
    completedtasksList.clear();
    print(cat);

    final res = await FirebaseFirestore.instance
        .collection('tasks')
        .where('CategoryName', isEqualTo: cat)
        .where('ListName', isEqualTo: list)
        .where('UID', arrayContains: FirebaseAuth.instance.currentUser!.email)
        .where('status', isEqualTo: 'completed')
        .get();
    for (int i = 0; i < res.docs.length; i++) {
      try {
        Tasksss taskss = Tasksss(
            id: res.docs[i].id,
            task: res.docs[i]['Task'],
            image: res.docs[i]['Image'],
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            list: res.docs[i]['ListName'],
            description: res.docs[i]['description'],
            value: false,
            showSubTasks: false,
            status: res.docs[i]['status'],
            deadline: res.docs[i]['Deadline']);

        completedtasksList.add(taskss);
      } catch (e) {
        Tasksss taskss = Tasksss(
            id: res.docs[i].id,
            task: res.docs[i]['Task'],
            image: "",
            status: res.docs[i]['status'],
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            list: res.docs[i]['ListName'],
            description: res.docs[i]['description'],
            value: false,
            showSubTasks: false,
            deadline: res.docs[i]['Deadline']);

        completedtasksList.add(taskss);
      }
      // Tasksss taskss = Tasksss(
      //     id: res.docs[i].id,
      //     task: res.docs[i]['Task'],
      //     image: res.docs[i]['Image'],
      //     priority: res.docs[i]['Priority'],
      //     category: res.docs[i]['CategoryName'],
      //     list: res.docs[i]['ListName'],
      //     description: res.docs[i]['description'],
      //     value: false,
      //     showSubTasks: false,
      //     deadline: res.docs[i]['Deadline']);
      //
      // completedtasksList.add(taskss);

      // tasks.add(res.docs[i]['Task']);
    }
    completedtasksList
        .sort((Tasksss a, Tasksss b) => a.deadline.compareTo(b.deadline));
    // print(tasks.length);
    completedtasksLoading = false;
    notifyListeners();
  }

  /*==========================================================================================*/

  bool taskListLoading = false;
  List<TaskListModel> taskList = [];

  getListForTask() async {
    taskList.clear();
    taskListLoading = true;
    notifyListeners();
    final res = await FirebaseFirestore.instance
        .collection('List')
        .where('UID', arrayContains: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (int i = 0; i < res.docs.length; i++) {
      TaskListModel task = TaskListModel(
          docId: res.docs[i].id,
          email: res.docs[i]['UID'],
          category: res.docs[i]['CategoryName'],
          list: res.docs[i]['List'],
          private: res.docs[i]['isPrivate']);

      taskList.add(task);
    }
    taskListLoading = false;
    notifyListeners();

    return taskList;
  }

/*==========================================================================================*/
  bool disableDropDown = true;
  List<TaskListModel> filteredtaskList = [];

  filterList(category) {
    print(taskList.length);
    disableDropDown = true;
    notifyListeners();
    filteredtaskList =
        taskList.where((element) => element.category == category).toList();
    if (filteredtaskList.isNotEmpty) {
      disableDropDown = false;
    }
    print(filteredtaskList.length);

    notifyListeners();
  }

  updateCheckboxValue(bool v, int index) async {
    tasksList[index].value = v;
    // notifyListeners();
    completedtasksList.add(tasksList[index]);
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(tasksList[index].id)
        .update({'status': 'completed'});
    tasksList.removeLast();
    // tasksList.removeAt(index);
    print("tasksList_3 ${tasksList.length}");
    notifyListeners();
  }

  List<Tasksss> allTasks = [];
  List<DateTime> toHighlight = [];
  bool allTasksLoading = false;
  getTasksofDate() async {
    allTasks = [];
    allTasksLoading = true;
    //allTasks.clear();
    notifyListeners();
    var res = await FirebaseFirestore.instance
        .collection('tasks')
        .where('UID', arrayContains: FirebaseAuth.instance.currentUser!.email)
        .get();
    for (int i = 0; i < res.docs.length; i++) {
      DateTime date = res.docs[i]['Deadline'].toDate();
      var date1 = DateFormat("yyyy-MM-dd").format(date);
      toHighlight.add(date);
      // print("date1 ${res.docs[i]['Task']}");

      try {
        Tasksss tasks = Tasksss(
            id: res.docs[i].id,
            task: res.docs[i]['Task'],
            image: res.docs[i]['Image'] ?? "",
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            list: res.docs[i]['ListName'],
            description: res.docs[i]['description'],
            status: res.docs[i]['status'],
            value: false,
            showSubTasks: false,
            deadline: date1);
        allTasks.add(tasks);
      } catch (e) {
        Tasksss tasks = Tasksss(
            id: res.docs[i].id,
            task: res.docs[i]['Task'],
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            image: "",
            list: res.docs[i]['ListName'],
            status: res.docs[i]['status'],
            description: res.docs[i]['description'],
            value: false,
            showSubTasks: false,
            deadline: date1);
        allTasks.add(tasks);
      }

      // allTasks.add(tasks);

      // tasks.add(res.docs[i]['Task']);
    }
    allTasksLoading = false;
    TasksModel.tasks = allTasks;
    print("eeee ${allTasks.length}");
    notifyListeners();
  }

  List<Tasksss> filteredTasks = [];

  filterTasksByDate(date) {
    // print(date);
    // print('tasksk' + TasksModel.tasks.length.toString());
    filteredTasks.clear();
    notifyListeners();
    filteredTasks = TasksModel.tasks.where((element) {
      String dateOnly = '';
      if (element.deadline.runtimeType == Timestamp) {
        Timestamp timestamp = element.deadline;
        DateTime dateTime = timestamp.toDate();
        dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);
      } else {
        DateTime convertedDateTime =
            DateTime.parse(element.deadline.toString());
        Timestamp timestamp = Timestamp.fromDate(convertedDateTime);
        DateTime dateTime = timestamp.toDate();
        dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);
      }
      return dateOnly.toString() == date.toString() &&
          element.status != "deleted";
      // return  element.deadline.toString() == date.toString();
    }).toList();
    print('filteredTasks ${filteredTasks.length}');
    notifyListeners();
  }

  List<Tasksss> checkingColor = [];
  getColorofDate(date) {
    var date1 = DateFormat("yyyy-MM-dd").format(date);
    checkingColor.clear();
    checkingColor = allTasks
        .where((element) =>
            element.deadline == date1 && element.priority == 'High')
        .toList();
    if (checkingColor.isNotEmpty) {
      return 'High';
    } else {
      checkingColor = allTasks
          .where((element) =>
              element.deadline == date1 && element.priority == 'Medium')
          .toList();
      if (checkingColor.isNotEmpty) {
        return 'Medium';
      } else {
        return 'Low';
      }
    }
  }
  /*=======================================Sub tasks=====================================================*/

//bool showSubTasks = false;
  updateShowSubTasks(val, i) {
    // task.showSubTasks = val;
    tasksList[i].showSubTasks = val;

    notifyListeners();
  }

  updateShowCompletedSubTasks(val, i) {
    completedtasksList[i].showSubTasks = val;
    notifyListeners();
  }

  List<SubTasks> subTasks = [];

  getSubTasks() async {
    subTasks.clear();
    var res = await FirebaseFirestore.instance
        .collection('sub-tasks')
        .where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    for (int i = 0; i < res.docs.length; i++) {
      SubTasks subTask = SubTasks(
          id: res.docs[i].id,
          uid: res.docs[i]['SubTask'],
          task: res.docs[i]['Task'],
          subTask: res.docs[i]['SubTask']);

      subTasks.add(subTask);
    }

    notifyListeners();
  }

  List<SubTasks> filteredSubTasks = [];

  fiterSubTask(task) {
    filteredSubTasks.clear();
    filteredSubTasks =
        subTasks.where((element) => element.task == task).toList();
    notifyListeners();
  }

  bool addNewSubTask = false;
  updateAddNewTaskValue(value) {
    addNewSubTask = value;
    notifyListeners();
  }

  bool editTask = false;
  updateEditTask(v) {
    editTask = v;
    notifyListeners();
  }

  bool imageLoading = false;
  ImagePicker picker = ImagePicker();
  var url =
      "https://www.srilankafoundation.org/wp-content/uploads/2020/12/dummy11-1.jpg";
  uploadTaskImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    XFile? image;
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print(e.toString());

      return '0';
    }
    if (image != null) {
      imageLoading = true;
      notifyListeners();
      //Create a reference to the location you want to upload to in firebase
      Reference reference = storage.ref().child("tasks");
      File file = File(image.path);

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
        url = await reference.getDownloadURL();
      }).catchError((onError) {
        print(onError);
      });
      imageLoading = false;
      notifyListeners();
      print(url);
      return url;
    } else {
      return '0';
    }
  }
}
