import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import '../../Util.dart';
import '../../homePage.dart';
import '../../utils/app_colors.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "Received invitation",
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 15,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Text(
                 // 'From: ' +
                    invitationModel.senderEmail +
                    ' Invite you'
                    '\nTo ' +
                    invitationModel.list +
                    ' list in '+invitationModel.category+
                    'category', 
                   
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
                child: IconButton(
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

                      // await FirebaseFirestore.instance.collection('List').add({
                      //   'CategoryName': invitationModel.category,
                      //   'List': invitationModel.list,
                      //   'UID': FirebaseAuth.instance.currentUser!.email,
                      //   'isPrivate': false,
                      // });

                      ///////////////////////////////////
                      await FirebaseFirestore.instance
                          .collection('List')
                          .doc(invitationModel.listId)
                          .set({
                        'UID': FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser!.email])
                      }, SetOptions(merge: true));

                      var res = await FirebaseFirestore.instance
                          .collection('tasks')
                          .where('ListName', isEqualTo: invitationModel.list)
                          .get();
                      for (int i = 0; i < res.docs.length; i++) {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(res.docs[i].id)
                            .set({
                          'UID': FieldValue.arrayUnion(
                              [FirebaseAuth.instance.currentUser!.email])
                        }, SetOptions(merge: true));
                      }
                      /////////////////////////////
                      ///
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: 'Invitation accepted successfully!',
                        confirmBtnColor: AppColors.deepPurple,
                        //   autoCloseDuration: Duration(seconds: 2),
                      );
                    },
                    icon: Icon(Icons.done_rounded),
                    color: Colors.green,
                    iconSize: 30,
                   /* child: const Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(151, 138, 238, 129)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    side: BorderSide(
                                      color: Color.fromARGB(151, 138, 238, 129),
                                      //  width: 1,
                                    ))))*/
                                    ),
              ),
              const SizedBox(
                height: 2,
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.25,
                child: IconButton(
                    onPressed: () async {
                      print(invitationModel.senderEmail);

                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          text:
                              'Are you sure you want to reject the invitation?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: () async {
                            await FirebaseFirestore.instance
                                .collection('invitations')
                                .doc(invitationModel.id)
                                .update({'status': 'rejected'});

                            Util.routeToWidget(context, NavBar(tabs: 0));
                          });
                    },
                     icon: Icon(Icons.cancel_outlined),
                     color: Color.fromARGB(255, 240, 96, 86),
                     iconSize: 30,
                   /* child: const Text(
                      "Reject",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(151, 241, 89, 78)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    side: BorderSide(
                                      color: Color.fromARGB(151, 241, 89, 78),
                                    ))))*/
                                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}