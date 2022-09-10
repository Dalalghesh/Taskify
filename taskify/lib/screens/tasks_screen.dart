import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/nav_bar.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key, this.onCloseTap}) : super(key: key);

  final VoidCallback? onCloseTap;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => NavBar(tabs: 1));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hello'),
          leading: GestureDetector(
            onTap: onCloseTap,
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const Center(
          child: Text(
              'This is TASK SCREEN'
          ),
        ),
      ),
    );
  }
}
