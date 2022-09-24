import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:taskify/invitation/models/invitation.dart';
import 'package:taskify/invitation/provider/invitation.dart';

import '../widget/single_invitation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:rxdart/rxdart.dart';

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
        appBar: AppBar(
          // leading: GestureDetector(
          //   onTap: () => Navigator.of(context).pop(),
          //   child: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {},
          //   ),
          // ),
          leadingWidth: 50,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              width: mediaQuery.size.width,
              child: Column(
                children: [
                  Text(
                    'Received Invitation',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                              recivereEmail: invitation[index].recivereEmail,
                              senderEmail: invitation[index].senderEmail,
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
