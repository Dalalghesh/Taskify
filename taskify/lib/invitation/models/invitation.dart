import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationModel {
  String? id;
  String senderEmail;
  String recivereEmail;
  String category;
  String list;
  String status;

  InvitationModel(
      {required this.recivereEmail,
      required this.senderEmail,
      this.id,
      required this.status,
      required this.category,
      required this.list});
  static const collectionName = "invitations";

  Map<String, dynamic> getMap() => {
        "senderEmail": senderEmail,
        "recieverEmail": recivereEmail,
        "status": 'pending',
        "category": category,
        "list": list
      };
  static List<InvitationModel> firebaseToObject(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    List<InvitationModel> invitations = [];
    for (var doc in docs) {
      print(doc.id);
      invitations.add(
        InvitationModel(
          id: doc.id,
          senderEmail: doc.data()["senderEmail"],
          recivereEmail: doc.data()["recieverEmail"],
          status: doc.data()["status"],
          category: doc.data()["category"],
          list: doc.data()["list"],
        ),
      );
    }
    return [...invitations];
  }
}
