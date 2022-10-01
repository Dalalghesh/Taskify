import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              title: Text(
                '  Received Invitation',
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
