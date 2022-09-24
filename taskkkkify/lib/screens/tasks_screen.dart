import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';

import '../controller/UserController.dart';

class TaskScreen extends StatefulWidget {
  final String category;
  final String list;

  TaskScreen({Key? key, required this.category, required this.list}) : super(key: key);

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
  getTask()async{
    print(widget.category);
    await Future.delayed(Duration(milliseconds: 200));
    Provider.of<AppState>(context, listen: false).getTasks(widget.category, widget.list);

  }
  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: provider.tasksLoading ? Center(child: CircularProgressIndicator(),): ListView.builder(
          itemCount: provider.tasks.length,
          shrinkWrap: true,

          itemBuilder: (context, index){
            return

              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3,

                      )
                    ],
                    borderRadius: BorderRadius.circular(8)
                ),
                alignment: Alignment.center,
                child: Text(provider.tasks[index]),
              );
          }),
    );
    // throw UnimplementedError();
  }
}
