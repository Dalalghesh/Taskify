import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/invitation/screens/received_invitations.dart';
// import '../../Util.dart';
import '../../homePage.dart';
import '../../utils/app_colors.dart';
import '../models/invitation.dart';

class SingleInvitaionItem extends StatelessWidget {
  const SingleInvitaionItem({
    Key? key,
    required this.invitationModel,
  }) : super(key: key);
  static String id = "ReceivedInvitation";
  final InvitationModel invitationModel;
  static String FullName = "Dalal";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    AppState provider = Provider.of<AppState>(context, listen: false);
    findname(invitationModel.senderEmail);
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
              Text(
                " " + "$FullName" + " invites you",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'To ' +
                    invitationModel.list +
                    ' list \n In ' +
                    invitationModel.category +
                    'category',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: mediaQuery.size.width * 0.25,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    minimumSize: Size(2000000, 15),
                  ),

                  onPressed: () async {
                    CoolAlert.show(
                      title: "Success",
                      context: context,
                      type: CoolAlertType.success,
                      text: 'Invitation accepted successfully!',
                      confirmBtnColor: AppColors.deepPurple,
                      // onConfirmBtnTap: () {
                      //   Navigator.of(context).pop();
                      // }
                    );

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
                  },

                  icon: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 15,
                  ),
                  //color: Colors.green,
                  label: Text(
                    'Accept',
                    style: const TextStyle(
                      inherit: false,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.25,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 216, 58, 47),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    minimumSize: Size(2000000, 15),
                  ),
                  onPressed: () async {
                    print(invitationModel.senderEmail);
                    void reject(InvitationModel ID) async {
                      await FirebaseFirestore.instance
                          .collection('invitations')
                          .doc(ID.id)
                          .update({'status': 'rejected'});
                    }

                    CoolAlert.show(
                        title: "Hmm..",
                        context: context,
                        type: CoolAlertType.confirm,
                        text: 'Are you sure you want to reject the invitation?',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () {
                          reject(invitationModel);

                          Navigator.of(context).pop();
                        });
                  },
                  icon: Icon(
                    Icons.highlight_off_rounded,
                    size: 16,
                  ),
                  //  color: Color.fromARGB(255, 240, 96, 86),
                  label: Text(
                    'Reject',
                    style: const TextStyle(
                      inherit: false,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  findname(String senderEmail) async {
    final _firebaseFirestore = FirebaseFirestore.instance;
    print(senderEmail);

    final res = await _firebaseFirestore
        .collection('users1')
        .where("email", isEqualTo: senderEmail)
        .get();

    if (res.docs.isNotEmpty) {
      for (int i = 0; i < res.docs.length; i++) {
        if (res.docs[i]['email'] == senderEmail) {
          print('1');
          print(res.docs[i]['firstName']);
          print(res.docs[i]['lastName']);
          print('2');
          String fullname =
              res.docs[i]['firstName'] + " " + res.docs[i]['lastName'];
          print(fullname);
          FullName = fullname;
          print(FullName);
        }
      }
    }
  }
}
