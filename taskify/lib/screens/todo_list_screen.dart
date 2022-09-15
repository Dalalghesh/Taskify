import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/nav_bar.dart';

import '../controller/UserController.dart';

class TodoList extends StatelessWidget {
  TodoList({Key? key}) : super(key: key);
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (sx) {
        var newList;

        newList = sx.todo[sx.index]["privateList"];

        print("/////$newList");
        return Scaffold(
          appBar: AppBar(
            title: Text(
              sx.getCategory.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
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
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* Text("${sx.todo[sx.index]}"),
                  Text("///${sx.todo[sx.index]["privateList"]}"),*/
                  ListView.builder(
                      itemCount: (newList as List).length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 6,
                            margin: EdgeInsets.all(10),
                            color: Colors.white70,
                            shadowColor: Colors.grey.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListTile(
                                            title: Text(
                                          '            ${newList[index]['taskLabel']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                        Divider(
                                          color: newList[index]['priority'] ==
                                                  "low"
                                              ? Colors.lightGreen
                                              : newList[index]['priority'] ==
                                                      "medium"
                                                  ? Colors.amberAccent
                                                  : Colors.red,
                                          indent: 20.0,
                                          endIndent: 10.0,
                                          thickness: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                      value: newList[index]["isDone"],
                                      onChanged: (bool? value) {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  /* ListView.builder(
                      itemCount:
                          (sx.todo[sx.index]["sharedList"] as List).length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 6,
                            margin: EdgeInsets.all(10),
                            color: Colors.white70,
                            shadowColor: Colors.blueGrey,
                            child: Row(
                              children: [
                                ListTile(
                                  title: Text(
                                    '${sx.todo[sx.index]["sharedList"][index]['taskLabel']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    'Secondary Text',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                Checkbox(
                                  value: sx.todo[sx.index]["sharedList"][index]
                                      ["isDone"],
                                  onChanged: (bool? value) {},
                                ),
                              ],
                            ),
                          ),
                        );
                      }),*/
                  /*    ListView.builder(
            itemCount: sx.todo[sx.index].length,
              itemBuilder: (BuildContext ctx, int index) {
                print("22222222222222222222222222222222222${ sx.todo[sx.index].length}");
                return Container(
                  width: 100,
                  child: Padding(
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
                                value: sx.todo[sx.index][sx.taskList][index]['isDone'],
                                onChanged: (bool? value) {

                                },
                              ),
                            ],
                          )
                          ,
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
                  ),
                );
              },
            )*/

                  /*GestureDetector(
                  onTap: () {
                    sx.setIsPrivate(true);
                    print(sx.categories[sx.index]['privateList']);
                    sx.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  },
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
                    child:
                    */ /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'PRIVATE LIST',
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.lock
                        ),
                      ],
                    )*/ /* ListView.builder(
                      itemCount: sx.categories[sx.index]["sharedList"].length,
                      itemBuilder: (BuildContext ctx, int index) {
                        print("${ sx.categories[sx.index]["sharedList"]}");
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
                                )
                                ,
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
                    )
                  ),
                ),*/
                  const SizedBox(height: 25),
                  /*   GestureDetector(
                  onTap: () {
                    sx.setIsPrivate(false);
                    print(sx.categories[sx.index]['sharedList']);
                    sx.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  },
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'SHARED LIST',
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                            Icons.people
                        ),
                      ],
                    ),
                  ),
                ),*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
