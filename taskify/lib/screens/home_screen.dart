import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controller/UserController.dart';
import 'package:taskify/nav_bar.dart';
import 'package:taskify/screens/categories_screen.dart';
import 'package:taskify/screens/tasks_screen.dart';
import 'package:taskify/screens/todo_list_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return WillPopScope(
      onWillPop: () async {
        Get.clearRouteTree();
        return false;
      },
      child: Scaffold(
        body: GetBuilder<UserController>(
          init: UserController(),
          builder: (sx) => PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CategoriesScreen(
                  onTap: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate
                  ),
              ),
              TodoList(
                  onCloseTap: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.decelerate),
                  onNextTap: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate),
              ),
              TasksScreen(
                onCloseTap: () {
                  pageController.previousPage(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.decelerate);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
