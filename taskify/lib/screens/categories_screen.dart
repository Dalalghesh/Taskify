import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controller/UserController.dart';
import 'package:table_calendar/table_calendar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (sx) => sx.isLoading ? const Center(child: CircularProgressIndicator()) : Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.03, left: 25, right: 25),
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
              Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount: sx.categories.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),

                        child: Text(
                            sx.categories[index]["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
