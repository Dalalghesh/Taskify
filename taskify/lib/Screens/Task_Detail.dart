import 'package:flutter/material.dart';
import 'package:taskify/models/tasks.dart';
import 'package:intl/intl.dart';

class TaskDetail extends StatelessWidget {
  final Tasksss task;
  const TaskDetail({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(123, 57, 237, 1),
          elevation: 0.0,
          centerTitle: true,
          // title: Text(
          //   'Task',
          //   style: TextStyle(
          //       fontSize: 19, color: Color.fromARGB(255, 255, 255, 255)),
          // ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 530,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      height: 530,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '   Task Name:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '    ' + task.task,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '   Priority:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),

                          Container(
                            // decoration: BoxDecoration(
                            //   color: task.priority == 'High'
                            //       ? Color.fromARGB(255, 223, 123, 123)
                            //       : priority == 'Medium'
                            //           ? Color.fromARGB(255, 223, 180, 123)
                            //           : Color.fromARGB(255, 152, 224, 154),
                            //   shape: BoxShape.circle,
                            // ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '    ' + task.priority,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 50,
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '   Deadline:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '    ' + task.deadline,
                              // '               ${dateTime.day}/${dateTime.month}/${dateTime.year}   -   ${dateTime.hour}:${dateTime.minute}' ,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '   Description:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '    ' + task.description,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 55,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Center(
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "My profile",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color.fromARGB(0, 255, 255, 255),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2.29,
                height: MediaQuery.of(context).size.width / 2.29,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/user-5.png'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff7b39ed);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
