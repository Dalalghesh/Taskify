import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/Add_Category.dart';
import 'package:taskify/screens/home_screen.dart';
import 'package:taskify/screens/tasks_screen.dart';

import 'screens/screens/todo_list_screen.dart';

class NavBar extends StatefulWidget {
  NavBar({Key? key, required this.tabs}) : super(key: key);

  final int tabs;

  @override
  NavBarState createState() => NavBarState();
}

Widget GetTab(int index) {
  print(index);
  if (index == 0) {
    return HomeScreen();
  } else if (index == 1) {
    return TodoList();
  } else {
    return TasksScreen();
  }
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      GetTab(widget.tabs),
      Container(
        height: Get.height,
        color: Colors.blue,
      ),
      Container(
        height: Get.height,
        color: Colors.pinkAccent,
      ),
      Container(
        height: Get.height,
        color: Colors.grey,
      )
    ];
    return CurvedNavBar(
      actionButton: CurvedActionBar(
          onTab: (value) {
            /// perform action here
            print(value);
          },
          activeIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xff3F1883), shape: BoxShape.circle),
            child: const Icon(
              Icons.add,
              size: 50,
              color: Colors.green,
            ),
          ),
          inActiveIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xff3F1883), shape: BoxShape.circle),
            child: const Icon(
              Icons.add,
              size: 50,
              color: Colors.white,
            ),
          ),
          text: ""),
      navBarBackgroundColor: const Color(0xff3F1883),
      appBarItems: [
        FABBottomAppBarItem(
          activeIcon: const Icon(
            Icons.home,
            color: Colors.green,
          ),
          inActiveIcon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          text: '',
        ),
        FABBottomAppBarItem(
          activeIcon: const Icon(
            Icons.notifications,
            color: Colors.green,
          ),
          inActiveIcon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          text: '',
        ),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.calendar_today_sharp,
              color: Colors.green,
            ),
            inActiveIcon: const Icon(
              Icons.calendar_today_sharp,
              color: Colors.white,
            ),
            text: ''),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.person,
              color: Colors.green,
            ),
            inActiveIcon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            text: ''),
      ],
      bodyItems: tabs,
      actionBarView: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.75,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 68, 43, 112),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Add_Category()));
                },
                child: const Text(
                  'ADD TASK',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: Get.width * 0.75,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 113, 67, 193),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Add_Category()));
                },
                child: const Text(
                  'ADD CATEGORY',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: Get.width * 0.75,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff3F1883),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Add_Category()));
                },
                child: const Text(
                  'ADD TODO LIST',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
