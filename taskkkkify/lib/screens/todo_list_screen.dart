import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/homePage.dart';
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
    // TODO: implement initState
    super.initState();
    getList();
  }
  getList()async{
print(widget.category);
    await Future.delayed(Duration(milliseconds: 200));
    Provider.of<AppState>(context, listen: false).getList(widget.category);
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

      body: provider.listLoading ? Center(child: CircularProgressIndicator(),): ListView.builder(
          itemCount: provider.list.length,
          shrinkWrap: true,

          itemBuilder: (context, index){
            return

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen(category: widget.category, list: provider.list[index])));
                },

                child: Container(
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
                child: Text(provider.list[index]),
            ),
              );
          }),
    );
   // throw UnimplementedError();
  }
}
