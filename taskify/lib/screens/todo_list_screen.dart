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
    // TODO: implement initState
    super.initState();
    getList();
  }
  getList()async{
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
        title: Text(widget.category, style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),

      body: provider.listLoading ? Center(child: CircularProgressIndicator(),):
      
      provider.list.isEmpty ?

      Center(child: Text('List is empty', style: TextStyle(color: Colors.black, fontSize: 18),)):
      ListView.builder(
          itemCount: provider.list.length,
          shrinkWrap: true,

          itemBuilder: (context, index){
            return

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskScreen(category: widget.category, list: provider.list[index].list)));
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/ 1.3,
                    margin: EdgeInsets.only(left: 20, right: 0, top: 6, bottom: 5),
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    //alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(provider.list[index].list),
                        provider.list[index].private? Icon(Icons.lock, color: Colors.black,) : Icon(Icons.people, color: Colors.black,)
                      ],
                    ),
            ),
                    provider.list[index].private?Container():
                  Container(
                    margin: EdgeInsets.only(right: 10, ),
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SendInvitation(list: (provider.list[index].list), category:  widget.category,)));
                      },
                        icon: Icon(Icons.share, color: Colors.grey.shade600),
                         ),
                  )

                  ],
                ),
              );
          }),
    );
   // throw UnimplementedError();
  }
}
