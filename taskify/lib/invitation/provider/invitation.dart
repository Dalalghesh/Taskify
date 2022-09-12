import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:taskify/invitation/models/invitation.dart';

class InvitaitonProvider with ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  List<InvitationModel> invitations = [];
  Future<void> sendInvitation(String email) async {
    //Getting current user email
    final currentUserEmail = _firebaseAuth.currentUser?.email;
    if (currentUserEmail == null || currentUserEmail.isEmpty) {
      throw "No email address found for the current user";
    } else if (currentUserEmail.trim() == email.trim()) {
      throw "You are inviting your own email address";
    }
    final temp = await _checkIfEmailExists(email);
    if (!temp) {
      throw "A user with that email does not exists";
    }
    final InvitationModel invitationModel =
        InvitationModel(recivereEmail: email, senderEmail: currentUserEmail);
    _firebaseFirestore
        .collection(InvitationModel.collectionName)
        .add(invitationModel.getMap());
  }

  Future<bool> _checkIfEmailExists(String email) async {
    try {
      final doc = await _firebaseFirestore
          .collection("users1")
          .where('email', isEqualTo: email.trim())
          .get();
      if (doc.docs.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getInv(String email) async* {
    try {
      yield* _firebaseFirestore
          .collection(InvitationModel.collectionName)
          .where("recieverEmail", isEqualTo: email)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<InvitationModel>> getInvitations() async* {
    try {
      final currentUserEmail = _firebaseAuth.currentUser?.email;
      if (currentUserEmail == null || currentUserEmail.isEmpty) {
        throw "No email address found for the current user";
      }
      final streamOfInvitaitons = _getInv(currentUserEmail);
      await for (final i in streamOfInvitaitons) {
        yield InvitationModel.firebaseToObject(i.docs);
      }
    } catch (e) {
      rethrow;
    }
  }
}
