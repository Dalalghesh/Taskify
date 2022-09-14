import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/nav_bar.dart';

class TodoList extends StatelessWidget {
  TodoList({Key? key, this.onCloseTap, this.onNextTap}) : super(key: key);
  final VoidCallback? onCloseTap;
  final VoidCallback? onNextTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        leading: GestureDetector(
          onTap: onCloseTap,
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: onNextTap,
          child: Text('Press'),
        ),
      ),
    );
  }
}
