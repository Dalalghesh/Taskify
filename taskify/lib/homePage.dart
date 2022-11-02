import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:taskify/invitation/screens/received_invitations.dart';
import 'package:taskify/screens/AddList.dart';
import 'package:taskify/screens/AddTask.dart';
import 'package:taskify/screens/Add_Category.dart';
import 'package:taskify/screens/ProfileScreen/profileScreen.dart';
import 'package:taskify/screens/homescreen.dart';
import 'package:taskify/screens/tasks_screen.dart';
import 'package:taskify/util.dart';
import 'screens/todo_list_screen.dart';
import 'package:taskify/CalendarScreen.dart';
import 'service/local_push_notification.dart';

class NavBar extends StatefulWidget {
  NavBar({Key? key, required this.tabs}) : super(key: key);

  initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage:$message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      // Navigator.of(context).pushNamed("ReceivedInvitation");
      //Util.routeToWidget(context, NavBar(tabs: 0));
    });
  }

  void initState() {
    //initNotifications();
    // TODO: implement initState
    initNotification();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    FirebaseMessaging.instance.subscribeToTopic('subscription');
  }

  final int tabs;

  @override
  NavBarState createState() => NavBarState();
}

Widget GetTab(int index) {
  print(index);
  if (index == 0) {
    return Home_Screen();
  } else if (index == 1) {
    return TodoList(
      category: '',
    );
  } else {
    return TaskScreen(
      category: '',
      list: '',
    );
  }
}

class NavBarState extends State<NavBar> {
  initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage:$message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      Navigator.of(context).pushNamed("Taskscompleted");
      //Util.routeToWidget(context, TaskScreen as Widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Home_Screen(),
      RecievedInvitations(),
      CalendarScreen(),
      // Container(
      //   height: Get.height,
      //   color: Color.fromARGB(255, 207, 205, 206),
      // ),
      HomeScreen()
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
                color: Color(0xff7b39ed), shape: BoxShape.circle),
            child: const Icon(
              Icons.add,
              size: 50,
              color: Color.fromARGB(255, 170, 170, 170),
            ),
          ),
          inActiveIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xff7b39ed), shape: BoxShape.circle),
            child: const Icon(
              Icons.add,
              size: 50,
              color: Colors.white,
            ),
          ),
          text: ""),
      navBarBackgroundColor: const Color(0xff7b39ed),
      appBarItems: [
        FABBottomAppBarItem(
          activeIcon: const Icon(
            Icons.home,
            color: Color.fromARGB(255, 170, 170, 170),
          ),
          inActiveIcon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          text: '',
        ),
        FABBottomAppBarItem(
          activeIcon: const Icon(
            Icons.person_add,
            color: Color.fromARGB(255, 170, 170, 170),
          ),
          inActiveIcon: const Icon(
            Icons.person_add,
            color: Colors.white,
          ),
          text: '',
        ),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.message,
              color: Color.fromARGB(255, 170, 170, 170),
            ),
            inActiveIcon: const Icon(
              Icons.message,
              color: Colors.white,
            ),
            text: ''),
        FABBottomAppBarItem(
            activeIcon: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 170, 170, 170),
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
            //dalal

            //dalal

            Container(
              width: Get.width * 0.5,
              height: Get.width * 0.2,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff7b39ed),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Add_Category()));
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.widgets,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Add Category",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                  height: 80,
                  margin: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                    color: Color(0xff7b39ed),
                    borderRadius: BorderRadius.circular(12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 3,
                    //     color: Colors.grey,
                    //   ),
                    // ],
                  ),
                  alignment: Alignment.center,
                  // child: Text(
                  //   provider.categories[index],
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600),
                  // ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              width: Get.width * 0.5,
              height: Get.width * 0.2,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff7b39ed),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddList()));
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.note_add,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Add List",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                  height: 80,
                  margin: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                    color: Color(0xff7b39ed),
                    borderRadius: BorderRadius.circular(12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 3,
                    //     color: Colors.grey,
                    //   ),
                    // ],
                  ),
                  alignment: Alignment.center,
                  // child: Text(
                  //   provider.categories[index],
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600),
                  // ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: Get.width * 0.5,
              height: Get.width * 0.2,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xff7b39ed),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddTask()));
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          //   Icons.border_color_rounded,
                          Icons.add_task,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Add Task",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                  height: 80,
                  margin: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                    color: Color(0xff7b39ed),
                    borderRadius: BorderRadius.circular(12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 3,
                    //     color: Colors.grey,
                    //   ),
                    // ],
                  ),
                  alignment: Alignment.center,
                  // child: Text(
                  //   provider.categories[index],
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*initNotifications(){
FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
  print("onMessage:$message");
 });
 FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print("onMessageOpenedApp: $message");
   Navigator.of(context).pushNamed("Taskscompleted");
    Util.routeToWidget(context, );
 });
 }*/
