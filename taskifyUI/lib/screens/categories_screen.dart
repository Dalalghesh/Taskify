import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controller/UserController.dart';
import 'package:table_calendar/table_calendar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (sx) => sx.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.03, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.now(),
                      daysOfWeekHeight: 12,
                      lastDay: DateTime.now(),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
