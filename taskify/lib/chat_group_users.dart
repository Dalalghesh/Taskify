import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/models/chat_groups.dart';
import 'package:taskify/utils/app_colors.dart';

class ChatGroupUsers extends StatefulWidget {
  final ChatGroups chatGroups;

  const ChatGroupUsers({Key? key, required this.chatGroups}) : super(key: key);

  @override
  State<ChatGroupUsers> createState() => _ChatGroupUsersState();
}

class _ChatGroupUsersState extends State<ChatGroupUsers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppState>(context, listen: false)
          .getChatGroupUsers(widget.chatGroups.users);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.deepPurple,
          elevation: 0.0,
          leadingWidth: 90,
          title: Text(
            widget.chatGroups.list,
            style: TextStyle(
                //fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: provider.usersLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Users',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${FirebaseAuth.instance.currentUser!.displayName} (Me)',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.chatGroupUsers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              provider.chatGroupUsers[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ));
  }
}
