import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
class InvitationModel {
  String? id;
  String senderEmail;
  String recivereEmail;
  InvitationModel(
      {required this.recivereEmail, required this.senderEmail, this.id});
  static const collectionName = "invitations";

  Map<String, dynamic> getMap() =>
      {"senderEmail": senderEmail, "recieverEmail": recivereEmail};
  static List<InvitationModel> firebaseToObject(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    List<InvitationModel> invitations = [];
    for (var doc in docs) {
      invitations.add(
        InvitationModel(
            id: doc.id,
            senderEmail: doc.data()["senderEmail"],
            recivereEmail: doc.data()["recieverEmail"]),
      );
    }
    return [...invitations];
  }
}
