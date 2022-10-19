import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  bool isLoading = false;
  List categories = [];
  PageController pageController = PageController();
  int index = 0;
  String category = '';
  bool isPrivate = false;
  String taskList = '';
  List todo = [];

  setIsPrivate(bool val) {
    if (val == true) {
      taskList = 'privateList';
      isPrivate = val;
      update();
    } else {
      taskList = 'sharedList';
      isPrivate = val;
      update();
    }
  }

  bool get getIsPrivate => isPrivate;

  setIndex(int val) {
    index = val;
    update();
  }

  int get getIndex => index;

  setCategory(String val) {
    category = val;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // addNewUser();
    //final user = FirebaseAuth.instance.currentUser?.email;
    //createNewCategory(Category(CategoryName: "University", isPrivate: true, List_Id: "2", UID: user!));
    getData();
    getTodoList();
  }

  getTodoList() async {
    //final user = FirebaseAuth.instance.currentUser?.email;
    await FirebaseFirestore.instance
        .collection('users')
        .doc('baaliboudjemaaens@gmail.com')
        .get()
        .then((value) {
      todo = value!['categories'];

      print("/////////**************${value!['categories']}");
    });
  }

  String get getCategory => category;

  getData() async {
    isLoading = true;
    update();
    //final user = FirebaseAuth.instance.currentUser?.email;
    await FirebaseFirestore.instance
        .collection('List')
        .doc('baaliboudjemaaens@gmail.com')
        .get()
        .then((value) {
      print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvv${value.data()}");
      var val = value.data();
      categories = val!['categories'];
      update();
    });
    print("///////////////////////////////////$categories!");
    isLoading = false;
    update();
  }
}
