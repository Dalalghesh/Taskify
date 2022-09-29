import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:taskify/invitation/models/invitation.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:taskify/models/users.dart';

class InvitaitonProvider with ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  List<InvitationModel> invitations = [];
  List<String> emails = [];
  List<String> filteredEmails = [];
  List<String> tokens = [];
   List<UserModel> modelEmails = []; List<String> 
  filteredTokens= [];
  List<UserModel> modelTokens = [];

  Future<void> getUsersEmail() async {
    final currentUserEmail = _firebaseAuth.currentUser?.email;
    final res = await _firebaseFirestore
        .collection('users1')
        .where("email", isNotEqualTo: currentUserEmail)
        .get();
    if (res.docs.isNotEmpty) {
      for (int i = 0; i < res.docs.length; i++) {
        UserModel userModel = UserModel(
            email: res.docs[i]['email'],
            categories: res.docs[i]['categories'],
            docId: res.docs[i].id);
        modelEmails.add(userModel);
        emails.add(res.docs[i]['email']);
      }
      filteredEmails = emails;
    }
    notifyListeners();
  }

  filterEmail(query) {
    filteredEmails = emails
        .where((element) => element.toLowerCase().contains(query))
        .toList();
    notifyListeners();
  }
  Future <String> getUsersToken() async {
    
    final currentUserEmail = _firebaseAuth.currentUser?.email;
    final sendEmail = '';

    final res = await _firebaseFirestore.collection('users1').where("email",isNotEqualTo:currentUserEmail).get();
    
    if(res.docs.isNotEmpty){

      for(int i =0; i< res.docs.length;i++){
        UserModel userModel = UserModel(
          email: res.docs[i]['email'],
          categories: res.docs[i]['categories'],
          docId: res.docs[i].id
        );
        modelTokens.add(userModel);

        tokens.add(res.docs[i]['token']);
      }
      filteredTokens = tokens;
    }
    notifyListeners();
    return '';
  }

  selectedUser(email) {
    SelectedUser.user =
        modelEmails.where((element) => element.email == email) as UserModel;
    notifyListeners();
  }

  Future<void> sendInvitation(
      String email, String category, String list) async {
    //Getting current user email
    final currentUserEmail = _firebaseAuth.currentUser?.email;
    if (currentUserEmail == null || currentUserEmail.isEmpty) {
      throw "";
    } else if (currentUserEmail.trim() == email.trim()) {
      throw "You are inviting your own email address";
    }
    final temp = await _checkIfEmailExists(email);
    if (!temp) {
      throw "A user with that email does not exists";
    }
    final InvitationModel invitationModel = InvitationModel(
        recivereEmail: email,
        senderEmail: currentUserEmail,
        status: 'pending',
        category: category,
        list: list);
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
          .where("status", isEqualTo: 'pending')
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<InvitationModel>> getInvitations() async* {
    final currentUserEmail = _firebaseAuth.currentUser?.email;
    if (currentUserEmail == null || currentUserEmail.isEmpty) {
      var context;
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "No email address found for the current user",
        confirmBtnColor: const Color(0xff7b39ed),
        // onConfirmBtnTap: () => route(isChecked),
      );
    }
    final streamOfInvitaitons = _getInv(currentUserEmail!);
    await for (final i in streamOfInvitaitons) {
      yield InvitationModel.firebaseToObject(i.docs);
    }
  }
}
