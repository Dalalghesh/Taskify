import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/invitation/screens/send_invitation.dart';
import 'package:taskify/screens/tasks_screen.dart';

import '../controller/UserController.dart';

class TodoList extends StatefulWidget {
  final String category;
  TodoList({Key? key, required this.category}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() async {
    print(widget.category);
    await Future.delayed(Duration(milliseconds: 100));
    Provider.of<AppState>(context, listen: false).getList(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.category,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff7b39ed),
      ),
      body: provider.listLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : provider.list.isEmpty
              ? Center(
                  child: Text(
                  'There are no lists yet',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ))
              : ListView.builder(
                  itemCount: provider.list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = provider.list[index].docId;

                    return Dismissible(
                        key: Key(item),
                        // background: Container(
                        //   alignment: Alignment.centerRight,
                        //   color: Colors.red,
                        //   child: const Icon(
                        //     Icons.delete,
                        //     size: 40.0,
                        //     color: Colors.white,
                        //   ),
                        // ),

                        confirmDismiss: (direction) {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                // CoolAlert.show(
                                //   title: "Hmm..",
                                //   context: context,
                                //   type: CoolAlertType.confirm,
                                //   text:
                                //       'Are you sure you want to delete this list?',
                                //   confirmBtnText: 'Yes',
                                //   cancelBtnText: 'No',
                                //   confirmBtnColor: Colors.green,
                                //   onConfirmBtnTap: () {
                                //     Navigator.of(context).pop(true);
                                //   },
                                //   onCancelBtnTap: () {
                                //     Navigator.of(context).pop(false);
                                //   },
                                //   // onCancelBtnTap:  Navigator.of(context).pop(),
                                // );
                                return AlertDialog(
                                  title: const Text('Hmm..'),
                                  content: const Text(
                                      'Are you sure you want to delete this list?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('no'),
                                    )
                                  ],
                                );
                              });
                        },
                        // confirmDismiss: (DismissDirection direction) async {
                        //   if (direction == DismissDirection.endToStart) {
                        // CoolAlert.show(
                        //   title: "Hmm..",
                        //   context: context,
                        //   type: CoolAlertType.confirm,
                        //   text:
                        //       'Are you sure you want to delete this list?',
                        //   confirmBtnText: 'Yes',
                        //   cancelBtnText: 'No',
                        //   confirmBtnColor: Colors.green,
                        //   onConfirmBtnTap: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   // onCancelBtnTap:  Navigator.of(context).pop(),
                        // );

                        //     return true;
                        //   }
                        // },
                        onDismissed: (direction) {},
                        background: slideLeftBackground(),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskScreen(
                                        category: widget.category,
                                        list: provider.list[index].list)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 1.1,
                                margin: EdgeInsets.only(
                                    left: 20, right: 0, top: 6, bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                //alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    provider.list[index].private
                                        ? Icon(
                                            Icons.lock,
                                            color: Color(0xff7b39ed),
                                          )
                                        : Icon(
                                            Icons.people,
                                            color: Color(0xff7b39ed),
                                          ),
                                    Text(
                                      provider.list[index].list,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    provider.list[index].private
                                        ? IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.share,
                                                color: Color.fromARGB(
                                                    0, 117, 117, 117)),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SendInvitation(
                                                            list: (provider
                                                                .list[index]
                                                                .list),
                                                            category:
                                                                widget.category,
                                                            listId: provider
                                                                .list[index]
                                                                .docId,
                                                          )));
                                            },
                                            icon: Icon(Icons.share,
                                                color: Colors.grey.shade600),
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  }),
    );
  }
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
