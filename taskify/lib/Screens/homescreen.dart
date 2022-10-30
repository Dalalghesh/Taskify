import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controller/UserController.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/screens/categories_screen.dart';
import 'package:taskify/screens/tasks_screen.dart';
import 'package:taskify/screens/todo_list_screen.dart';

class Home_Screen extends StatelessWidget {
  Home_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.clearRouteTree();
        return false;
      },
      child: Scaffold(
        body: GetBuilder<UserController>(
          init: UserController(),
          builder: (sx) => PageView(
            controller: sx.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CategoriesScreen(),
              TodoList(category: ''),
              TaskScreen(
                category: '',
                list: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
