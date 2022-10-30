import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:taskify/Screens/tasks_screen.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/invitation/models/invitation.dart';
import 'package:taskify/invitation/provider/invitation.dart';

import '../widget/single_invitation.dart';

class RecievedInvitations extends StatelessWidget {
  static const routeName = "/recieve-invitaiton";
  RecievedInvitations({Key? key}) : super(key: key);
  final _firestore = FirebaseFirestore.instance;

  void getCategory() async {
    final Categorys = await _firestore.collection('Category').get();
    for (var Category in Categorys.docs) {
      print(Category.data());
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   AppState provider = Provider.of<AppState>(context);
  //   // TODO: implement build

  //   return buildColumnNew(context, provider);
  // }

  // List<TasksCn> tasks = [];

  // Widget buildColumnNew(BuildContext context, AppState provider) {
  //   final mediaQuery = MediaQuery.of(context);

  //   return DefaultTabController(
  //       length: 2,
  //       child: Scaffold(
  //         appBar: PreferredSize(
  //             preferredSize: Size.fromHeight(45.0),
  //             child: AppBar(
  //               backgroundColor: Color(0xff7b39ed),
  //               title: Text(
  //                 '           Invitation',
  //                 style: TextStyle(
  //                     color: Color.fromARGB(255, 255, 255, 255),
  //                     height: 2,
  //                     //  fontWeight: FontWeight.bold,
  //                     fontSize: 23),
  //               ),
  //               leading: IconButton(
  //                 icon: Icon(Icons.arrow_back, color: Colors.transparent),
  //                 onPressed: () {},
  //               ),
  //             )),
  //         body: Column(
  //           children: <Widget>[
  //             SizedBox(
  //               height: 50,
  //               child: AppBar(
  //                 // foregroundColor: Colors.red,
  //                 backgroundColor: Color(0xff7b39ed),
  //                 bottom: TabBar(
  //                   tabs: [
  //                     Tab(
  //                       child: Container(
  //                           width: MediaQuery.of(context).size.width * 0.65,
  //                           // height: 100,
  //                           decoration: BoxDecoration(
  //                             //  border: Border.all(width: 1),
  //                             shape: BoxShape.rectangle,
  //                             // You can use like this way or like the below line
  //                             borderRadius: new BorderRadius.circular(10.0),
  //                             color: Color(0xff7b39ed),
  //                           ),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Center(child: const Text("Received")),
  //                           )),
  //                     ),
  //                     Tab(
  //                       child: Container(
  //                           width: MediaQuery.of(context).size.width * 0.65,
  //                           // height: 100,
  //                           decoration: BoxDecoration(
  //                             //  border: Border.all(width: 1),
  //                             shape: BoxShape.rectangle,
  //                             // You can use like this way or like the below line
  //                             borderRadius: new BorderRadius.circular(10.0),
  //                             color: Color(0xff7b39ed),
  //                           ),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Center(child: const Text("Sending")),
  //                           )),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),

  //             // create widgets for each tab bar here
  //             Expanded(
  //               child: TabBarView(
  //                 children: [
  //                   Container(
  //                       padding: const EdgeInsets.all(16.0),
  //                       width: mediaQuery.size.width,
  //                       child: Column(
  //                         children: [
  //                           StreamBuilder(
  //                             stream: context
  //                                 .read<InvitaitonProvider>()
  //                                 .getInvitations(),
  //                             builder: (context, snapshot) {
  //                               if (snapshot.error != null) {
  //                                 return Text(snapshot.error.toString());
  //                               } else if (snapshot.hasData) {
  //                                 List<InvitationModel> invitation =
  //                                     (snapshot.data as List<InvitationModel>);
  //                                 if (invitation.isEmpty) {
  //                                   return Center(
  //                                       child: Text(
  //                                     "There are no requests received yet",
  //                                   ));
  //                                 }
  //                                 return ListView.builder(
  //                                   itemBuilder: (context, index) =>
  //                                       SingleInvitaionItem(
  //                                     invitationModel: InvitationModel(
  //                                       id: invitation[index].id,
  //                                       listId: invitation[index].listId,
  //                                       recivereEmail: invitation[index]
  //                                           .recivereEmail
  //                                           .toLowerCase(),
  //                                       senderEmail: invitation[index]
  //                                           .senderEmail
  //                                           .toLowerCase(),
  //                                       status: invitation[index].status,
  //                                       category: invitation[index].category,
  //                                       list: invitation[index].list,
  //                                     ),
  //                                   ),
  //                                   itemCount: invitation.length,
  //                                   shrinkWrap: true,
  //                                   physics:
  //                                       const NeverScrollableScrollPhysics(),
  //                                 );
  //                               } else if (snapshot.connectionState ==
  //                                   ConnectionState.waiting) {
  //                                 return const Center(
  //                                   child: Text("Loading...."),
  //                                 );
  //                               }
  //                               return const Text(
  //                                   'There are no requests received yet');
  //                             },
  //                           )
  //                         ],
  //                       )),

  //                   Container(
  //                       padding: const EdgeInsets.all(16.0),
  //                       width: mediaQuery.size.width,
  //                       child: Column(
  //                         children: [
  //                           StreamBuilder(
  //                             stream: context
  //                                 .read<InvitaitonProvider>()
  //                                 .getInvitations(),
  //                             builder: (context, snapshot) {
  //                               if (snapshot.error != null) {
  //                                 return Text(snapshot.error.toString());
  //                               } else if (snapshot.hasData) {
  //                                 List<InvitationModel> invitation =
  //                                     (snapshot.data as List<InvitationModel>);
  //                                 if (invitation.isEmpty) {
  //                                   return Center(
  //                                       child: Text(
  //                                     'There are no requests yet',
  //                                   ));
  //                                 }
  //                                 return ListView.builder(
  //                                   itemBuilder: (context, index) =>
  //                                       SingleInvitaionItem(
  //                                     invitationModel: InvitationModel(
  //                                       id: invitation[index].id,
  //                                       listId: invitation[index].listId,
  //                                       recivereEmail: invitation[index]
  //                                           .recivereEmail
  //                                           .toLowerCase(),
  //                                       senderEmail: invitation[index]
  //                                           .senderEmail
  //                                           .toLowerCase(),
  //                                       status: invitation[index].status,
  //                                       category: invitation[index].category,
  //                                       list: invitation[index].list,
  //                                     ),
  //                                   ),
  //                                   itemCount: invitation.length,
  //                                   shrinkWrap: true,
  //                                   physics:
  //                                       const NeverScrollableScrollPhysics(),
  //                                 );
  //                               } else if (snapshot.connectionState ==
  //                                   ConnectionState.waiting) {
  //                                 return const Center(
  //                                   child: Text("Loading...."),
  //                                 );
  //                               }

  //                               return const Text(
  //                                   'There are no requests sent yet');
  //                             },
  //                           )
  //                         ],
  //                       )),

  //                   /// Completed
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: AppBar(
              title: Text(
                'Invitations',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.transparent),
                onPressed: () {},
              ),
            )),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              width: mediaQuery.size.width,
              child: Column(
                children: [
                  StreamBuilder(
                    stream: context.read<InvitaitonProvider>().getInvitations(),
                    builder: (context, snapshot) {
                      if (snapshot.error != null) {
                        return Text(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        List<InvitationModel> invitation =
                            (snapshot.data as List<InvitationModel>);
                        if (invitation.isEmpty) {
                          return const Text("You have no invitations");
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) => SingleInvitaionItem(
                            invitationModel: InvitationModel(
                              x: "s",
                              id: invitation[index].id,
                              listId: invitation[index].listId,
                              recivereEmail:
                                  invitation[index].recivereEmail.toLowerCase(),
                              senderEmail:
                                  invitation[index].senderEmail.toLowerCase(),
                              status: invitation[index].status,
                              category: invitation[index].category,
                              list: invitation[index].list,
                            ),
                          ),
                          itemCount: invitation.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading...."),
                        );
                      }
                      return const Text("You have no invitations");
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}
