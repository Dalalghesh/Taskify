import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tasks.dart';
import '../screens/Task_Detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  List<Tasksss> tasksList = [];
  List<Tasksss> tasksListSearch = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(microseconds: 3)).then((value) async {
      await getTasks();
      setState(() {});
    });
  }

  Future getTasks() async {
    final res = await FirebaseFirestore.instance
        .collection('tasks')
        // .where('Task', isEqualTo: textController.text)
        // .where('ListName', isEqualTo: list)
        .where('UID', arrayContains: FirebaseAuth.instance.currentUser!.email)
        // .where('status', isEqualTo: 'pending')
        .get();
    for (int i = 0; i < res.docs.length; i++) {
      try {
        Tasksss taskss = Tasksss(
            id: res.docs[i].id,
            image: res.docs[i]['Image'],
            task: res.docs[i]['Task'],
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            list: res.docs[i]['ListName'],
            description: res.docs[i]['description'],
            value: false,
            status: res.docs[i]['status'],
            showSubTasks: false,
            deadline: res.docs[i]['Deadline'],

            showAssignedMembers: false,
            // assignedMembers: [],
            assignedMembers: res.docs[i].data().toString().contains('assignedMembers') ? res.docs[i]['assignedMembers'] : [],

            manage: false


        );

        tasksList.add(taskss);
      } catch (e) {
        Tasksss taskss = Tasksss(
            id: res.docs[i].id,
            status: res.docs[i]['status'],
            image: "",
            task: res.docs[i]['Task'],
            priority: res.docs[i]['Priority'],
            category: res.docs[i]['CategoryName'],
            list: res.docs[i]['ListName'],
            description: res.docs[i]['description'],
            value: false,
            showSubTasks: false,
            showAssignedMembers: false,
            // assignedMembers: [],
            assignedMembers: res.docs[i].data().toString().contains('assignedMembers') ? res.docs[i]['assignedMembers'] : [],

            manage: false,
            deadline: res.docs[i]['Deadline']);

        tasksList.add(taskss);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff7b39ed),
        title: const Text("Search Page"),
      ),
      body: buildColumnList(),
    );
  }

  Column buildColumnList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            onChanged: (value) async {
              onSearchTextChanged(value);
            },
            style: TextStyle(
              fontSize: 15,
            ),
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                // onPressed: storeController.clear,
                onPressed: () {
                  setState(() {
                    tasksListSearch.clear();
                    textController.clear();
                  });
                },
                icon: Icon(Icons.clear),
              ),
              contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
              hintText: "Task Name",
              filled: true,
              // fillColor: Theme_Information.Color_1,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xff7b39ed), width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xff7b39ed), width: 0.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                tasksListSearch.isEmpty
                    ? const Center(
                        child: Text(
                        '',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ))
                    : ListView.builder(
                        itemCount: tasksListSearch.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Timestamp timestamp = tasksListSearch[index].deadline;
                          DateTime dateTime = timestamp.toDate();
                          bool isAfterDeadLine =
                              DateTime.now().isAfter(dateTime);
                          String dateOnly =
                              DateFormat('dd/MM/yyyy').format(dateTime);

                          // return buildInkWellTask(index);
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskDetail(
                                              // TaskDetails(
                                              index: index,
                                              isConpleted: true,
                                              task: tasksListSearch[index],
                                              taskOld: tasksListSearch[index],
                                            )));
                              },
                              child: Container(
                                // height: 50,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey,
                                    //     blurRadius: 3,
                                    //   )
                                    // ],
                                    borderRadius: BorderRadius.circular(8)),
                                //alignment: Alignment.center,
                                child: Padding(
                                  // padding: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.only(
                                      right: 8.0,
                                      left: 8.0,
                                      bottom: 15.0,
                                      top: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            margin: EdgeInsets.only(left: 16),
                                            decoration: BoxDecoration(
                                              color: tasksListSearch[index]
                                                          .priority ==
                                                      'High'
                                                  ? Color.fromARGB(
                                                      255, 223, 123, 123)
                                                  : tasksListSearch[index]
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
                                            tasksListSearch[index].task,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            '${dateOnly}',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InkWell buildInkWellTask(int index) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TaskScreen(
        //             category: tasksList[index].category,
        //             list: tasksList[index].list))).then((value) {
        //   getList();
        //   setState(() {
        //   });
        // });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              //alignment: Alignment.center,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tasksListSearch[index].task,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    // _searchResult.clear();
    tasksListSearch.clear();
    if (text.isEmpty) {
      //
      setState(() {});
      return;
      // futureMethod = getLeadsInformation();
      // return;
    }
    // print(text);

    tasksList.forEach((userDetail) {
      if (userDetail.task.toLowerCase().contains(text.toLowerCase())) {
        print(userDetail.task);
        tasksListSearch.add(userDetail);
      }
    });
    setState(() {});
    // fromWhere = "filter";
    // futureMethod = getLeadsInformation();
    // setState(() {});
  }
}
