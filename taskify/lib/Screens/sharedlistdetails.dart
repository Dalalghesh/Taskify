// import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:googleapis/photoslibrary/v1.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/invitation/screens/send_invitation.dart';
import 'package:taskify/Screens/tasks_screen.dart';
import '../controller/UserController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class sharedlistdetails extends StatefulWidget {
  final String category;
  final String list;
  // final String listid;

  sharedlistdetails({
    Key? key,
    required this.category,
    required this.list,
    // required this.listid
  }) : super(key: key);

  @override
  State<sharedlistdetails> createState() => _sharedlistdetails();
}

class _sharedlistdetails extends State<sharedlistdetails> {
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  late TaskListModel task;
  getMembers() async {
    print("categoreeeeeeeeey");
    print(widget.category);
    print("liiiiiissssssttttt");
    print(widget.list);
    await Future.delayed(Duration(milliseconds: 100));
    Provider.of<AppState>(context, listen: false)
        .getMembers(widget.category, widget.list); // getTaskWithoutClear();
  }

  late List members;
  String x = '';
  var userEmail = '';
  var name = '';
  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.list + ' members',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          backgroundColor: Color(0xff7b39ed),
        ),
        body: Column(
          children: [
            provider.listLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.membersInfo.isEmpty
                    ? Center(
                        child: Text(
                        'There are no members yet',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ))
                    : ListView.builder(
                        itemCount: provider.membersInfo.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 70,
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 0, top: 6, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 25, // Image radius
                                        backgroundImage: NetworkImage(
                                            provider.membersInfo[index].photo),
                                      ),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              provider
                                                  .membersInfo[index].fullname,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              provider.membersInfo[index].email,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
                                          ]),
                                      if (provider.membersInfo[index].email ==
                                          provider.membersInfo[0].email)
                                        Text(
                                          "Admin",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 104, 104, 104)),
                                        ),
                                      if (FirebaseAuth.instance.currentUser!
                                                  .email !=
                                              provider.membersInfo[0].email &&
                                          provider.membersInfo[index].email !=
                                              provider.membersInfo[0].email)
                                        Text(
                                          " ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 104, 104, 104)),
                                        ),
                                      if (FirebaseAuth.instance.currentUser!
                                                  .email ==
                                              provider.membersInfo[0].email &&
                                          FirebaseAuth.instance.currentUser!
                                                  .email !=
                                              provider.membersInfo[index].email)
                                        IconButton(
                                          onPressed: () async {
                                            print("clicked");

                                            Widget cancelButton = TextButton(
                                              child: Text("Yes"),
                                              onPressed: () async {
                                                 final resremove =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('invitations')
                                                        .where('category',
                                                            isEqualTo:
                                                                widget.category)
                                                        .where('list',
                                                            isEqualTo: provider
                                                                .list[index]
                                                                .list)
                                                        .where('status',
                                                            isEqualTo: "accepted") 
                                                        .get();

                                                             if (resremove.docs.length != 0)
                                                  for (int i = 0;
                                                      i < resremove.docs.length;
                                                      i++) {

                                                    DocumentReference docRef2 =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('invitations')
                                                            .doc(
                                                                resremove.docs[i].id);

                                                    docRef2.update({
                                                      'status': "rejected" 
                                                    });
                                                  }

                                                  
                                                // });
                                                DocumentReference docRef =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('List')
                                                        .doc(provider.docid);
                                                docRef.update({
                                                  'UID':
                                                      FieldValue.arrayRemove([
                                                    provider.membersInfo[index]
                                                        .email
                                                  ])
                                                });

                                                setState(() {
                                                  provider.membersInfo
                                                      .removeWhere((item) =>
                                                          item.email ==
                                                          provider
                                                              .membersInfo[
                                                                  index]
                                                              .email);

                                                  provider.membersInfo.length;
                                                });

                                                final res =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('tasks')
                                                        .where('CategoryName',
                                                            isEqualTo:
                                                                widget.category)
                                                        .where('ListName',
                                                            isEqualTo: provider
                                                                .list[index]
                                                                .list)
                                                        .where('UID',
                                                            arrayContains:
                                                                provider
                                                                    .membersInfo[
                                                                        index]
                                                                    .email)
                                                        .get();

                                                Navigator.of(context).pop(true);

                                                if (res.docs.length != 0)
                                                  for (int i = 0;
                                                      i < res.docs.length;
                                                      i++) {
                                                    DocumentReference docRef2 =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('tasks')
                                                            .doc(
                                                                res.docs[i].id);

                                                    docRef2.update({
                                                      'UID': FieldValue
                                                          .arrayRemove([
                                                        provider
                                                            .membersInfo[index]
                                                            .email
                                                      ])
                                                    });
                                                  }
                                                Navigator.of(context).pop(true);
                                              },
                                            );
                                            Widget continueButton = TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            );
                                            
                                            // set up the AlertDialog
                                            AlertDialog alert = AlertDialog(
                                              title: Text("Remove member"),
                                              content: Text(
                                                  "Are you sure you want to remove (${provider.membersInfo[index].fullname}) ?"),
                                              actions: [
                                                cancelButton,
                                                continueButton,
                                              ],
                                            );

                                            // show the dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.close,
                                              color: Color.fromARGB(
                                                  255, 117, 117, 117)),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
            Column(
              children: [
                Container(
                  height: 55,
                  width: 280,
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        minimumSize: Size(2000000, 15),
                      ),
                      onPressed: () async {
                        print('||||||||||||||||||||||||||||||||');
                        print(widget.category);
                        print(widget.list);
                        print('||||||||||||||||||||||||||||||||');

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendInvitation(
                                    category: widget.category,
                                    list: widget.list,
                                    listId: provider.docid)));
                      },
                      child: Text(
                        'Invite Friend',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
