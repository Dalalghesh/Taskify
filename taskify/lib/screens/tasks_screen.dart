import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';

import '../controller/UserController.dart';

class TaskScreen extends StatefulWidget {
  final String category;
  final String list;

  TaskScreen({Key? key, required this.category, required this.list})
      : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTask();
  }

  getTask() async {
    print(widget.category);
    await Future.delayed(Duration(milliseconds: 100));
    Provider.of<AppState>(context, listen: false)
        .getTasks(widget.category, widget.list);
    Provider.of<AppState>(context, listen: false)
        .getCompletedTasks(widget.category, widget.list);
  }

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          // elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.list,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: provider.tasksLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : provider.tasksList.isEmpty
                      ? Center(
                          child: Text(
                          'List is empty',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ))
                      : ListView.builder(
                          itemCount: provider.tasksList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8)),
                              //alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: EdgeInsets.only(left: 16),
                                    decoration: BoxDecoration(
                                      color: provider
                                                  .tasksList[index].priority ==
                                              'High'
                                          ? Color.fromARGB(255, 223, 123, 123)
                                          : provider.tasksList[index]
                                                      .priority ==
                                                  'Medium'
                                              ? Color.fromARGB(
                                                  255, 223, 180, 123)
                                              : Color.fromARGB(
                                                  255, 152, 224, 154),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                    provider.tasksList[index].task,
                                    textAlign: TextAlign.left,
                                  ),
                                  Checkbox(
                                      value: provider.tasksList[index].value,
                                      onChanged: (v) {
                                        provider.updateCheckboxValue(v!, index);
                                      })
                                ],
                              ),
                            );
                          }),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Completed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: provider.completedtasksLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : provider.completedtasksList.isEmpty
                      ? Center(
                          child: Text(
                          'List is empty',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ))
                      : ListView.builder(
                          itemCount: provider.completedtasksList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                //    DateTime date = provider.completedtasksList[index].deadline.toDate();
                                // var date1 =   DateFormat("yyyy-MM-dd").format(date);
                                //   print(date1);
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 3,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8)),
                                //alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(left: 16),
                                      decoration: BoxDecoration(
                                        color: provider
                                                    .completedtasksList[index]
                                                    .priority ==
                                                'High'
                                            ? Color.fromARGB(255, 223, 123, 123)
                                            : provider.completedtasksList[index]
                                                        .priority ==
                                                    'Medium'
                                                ? Color.fromARGB(
                                                    255, 223, 180, 123)
                                                : Color.fromARGB(
                                                    255, 152, 224, 154),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(
                                      provider.completedtasksList[index].task,
                                      textAlign: TextAlign.left,
                                    ),
                                    Container(),

                                    // Checkbox(value: provider.tasksList[index].value, onChanged: (v){
                                    //   provider.updateCheckboxValue(v!, index);
                                    // })
                                  ],
                                ),
                              ),
                            );
                          }),
            ),
          ],
        ));
    // throw UnimplementedError();
  }
}
