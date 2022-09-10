
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController{

  bool isLoading = false;
  List categories = [];
  PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    isLoading = true;
    update();
    await FirebaseFirestore
        .instance
        .collection('users')
        .doc('2IxdtFTVyEfvKEttZXFy')
        .get()
        .then((value) {
          var val = value.data();
          categories = val!['categories'];
          update();
    });
    print(categories);
    isLoading = false;
    update();
  }
}