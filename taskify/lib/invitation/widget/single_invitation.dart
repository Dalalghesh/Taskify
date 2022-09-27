import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';

import '../models/invitation.dart';

class SingleInvitaionItem extends StatelessWidget {
  const SingleInvitaionItem({
    Key? key,
    required this.invitationModel,
  }) : super(key: key);
  final InvitationModel invitationModel;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    AppState provider = Provider.of<AppState>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     // spreadRadius: 1,
        //     //  blurRadius: 1,
        //   )
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Received invitation from",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                invitationModel.senderEmail +
                    ' to list ' +
                    invitationModel.list,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: mediaQuery.size.width * 0.25,
                child: ElevatedButton(
                    onPressed: () async {
                      print(invitationModel.category);
                      await FirebaseFirestore.instance
                          .collection('invitations')
                          .doc(invitationModel.id)
                          .update({'status': 'accepted'});

                      provider.categories.contains(invitationModel.category)
                          ? ''
                          : await FirebaseFirestore.instance
                              .collection('users1')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                              'categories': FieldValue.arrayUnion(
                                  [invitationModel.category])
                            }, SetOptions(merge: true));

                      await FirebaseFirestore.instance.collection('List').add({
                        'CategoryName': invitationModel.category,
                        'List': invitationModel.list,
                        'UID': FirebaseAuth.instance.currentUser!.email,
                        'isPrivate': false,
                      });
                    },
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 144, 197, 139)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 144, 197, 139),
                                      width: 1,
                                    ))))),
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.25,
                child: ElevatedButton(
                    onPressed: () async {
                      print(invitationModel.senderEmail);
                      await FirebaseFirestore.instance
                          .collection('invitations')
                          .doc(invitationModel.id)
                          .update({'status': 'rejected'});
                    },
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 228, 111, 103)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 228, 111, 103),
                                      width: 2,
                                    ))))
                    // style: ButtonStyle(
                    //   backgroundColor: Colors.white,
                    //     shape:
                    //         MaterialStateProperty.all<RoundedRectangleBorder>(
                    //             RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(18.0),
                    //                 side: BorderSide(color: Colors.red))))

                    // style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     primary: Color.fromARGB(255, 232, 107, 98)),
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
