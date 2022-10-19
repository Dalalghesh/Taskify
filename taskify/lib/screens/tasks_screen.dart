import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/controller/UserController.dart';

class TasksScreen extends StatefulWidget {
  TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (sx) => Scaffold(
        appBar: AppBar(
          title: Text(sx.getIsPrivate ? 'PRIVATE LIST' : 'SHARED LIST',style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
          elevation: 0,
          bottomOpacity: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              sx.pageController.previousPage(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.decelerate);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black,),
          ),
        ),
        body: ListView.builder(
          itemCount: sx.categories[sx.index][sx.taskList].length,
          itemBuilder: (BuildContext ctx, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
              child: Container(
                width: Get.width * 0.75,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TASK:  ${sx.categories[sx.index][sx.taskList][index]['taskLabel'].toString().toUpperCase()}',
                          softWrap: true,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                        Checkbox(
                          value: sx.categories[sx.index][sx.taskList][index]['isDone'],
                          onChanged: (bool? value) {

                          },
                        ),
                      ],
                    ),
                    const Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      sx.categories[sx.index][sx.taskList][index]['description'].toString(),
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        fontSize: 14
                      ),
                    ),
                    const SizedBox(height: 20),
                    if(sx.categories[sx.index][sx.taskList][index]['priority'].toString() == "high")
                      Container(
                        height: 10,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    if(sx.categories[sx.index][sx.taskList][index]['priority'].toString() == "medium")
                      Container(
                        height: 10,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    if(sx.categories[sx.index][sx.taskList][index]['priority'].toString() == "low")
                      Container(
                        height: 10,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    // Text(
                    //   'PRIORITY: ${sx.categories[sx.index][sx.taskList][index]['priority'].toString().toUpperCase()}',
                    //   style: const TextStyle(
                    //     color: Color(0xff3F1883),
                    //     fontWeight: FontWeight.bold
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Text(
                      'DEADLINE: ${sx.categories[sx.index][sx.taskList][index]['deadline'].toString().toUpperCase()}',
                      style: const TextStyle(
                          color: Color(0xff3F1883),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 15),
                    if(sx.isPrivate == false)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MEMBERS',
                            style: TextStyle(
                                color: Color(0xff3F1883),
                                fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                          ),
                          const SizedBox(height: 10),
                          for(int i = 0; i < sx.categories[sx.index][sx.taskList][index]['members'].length; i++)
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Color(0xff3F1883),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  sx.categories[sx.index][sx.taskList][index]['members'][i].toString(),
                                  style: const TextStyle(
                                      color: Color(0xff3F1883),
                                      fontWeight: FontWeight.w500,
                                    fontSize: 16
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

