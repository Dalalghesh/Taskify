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
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: provider.listLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : provider.list.isEmpty
              ? Center(
                  child: Text(
                  'List is empty',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ))
              : ListView.builder(
                  itemCount: provider.list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('added successfully '),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('completed!'),
              Text('Would you like to cancel ?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('completed'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

link

                                final suuper = Container(
  padding: const EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      stars,
      const Text(
        ' tasks',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          fontSize: 20,
        ),
      ),
    ],
  ),
);
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
                                padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
        );
      },
    );
  }
                                    : IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SendInvitation(
                                                        list: (provider
                                                            .list[index].list),
                                                        category:
                                                            widget.category,
                                                        listId: provider
                                                            .list[index].docId,
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
                    );
                  }),
    );
    // throw UnimplementedError();
  }
}
