import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/Screens/AddList.dart';
import '../../service/local_push_notification.dart';
import '../../util.dart';
import '../../utils/validators.dart';
import '../provider/invitation.dart';
import '../screens/received_invitations.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:taskify/models/users.dart';

class SendInvitationForm extends StatefulWidget {
  String category;
  String list;
  String listId;

  SendInvitationForm({
    Key? key,
    required this.category,
    required this.list,
    required this.listId,
  }) : super(key: key);

  @override
  State<SendInvitationForm> createState() => _SendInvitationFormState();
}

class _SendInvitationFormState extends State<SendInvitationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String query = '';
  String? email;
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  List<String> tokens = [];
  List<String> filteredEmails = [];
  List<UserModel> modelTokens = [];

  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    FirebaseMessaging.instance.subscribeToTopic('subscription');
  }

 Future<void> sendInviation(String recieverEmail, String listId) async {
  try {
    final validate = _formKey.currentState?.validate();
    if (validate ?? false) {
      _formKey.currentState?.save();
      await context.read<InvitaitonProvider>().sendInvitation(
          email!, widget.category, widget.list, widget.listId);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Invitation sent successfully",
        confirmBtnColor: const Color(0xff7b39ed),
      );
      _formKey.currentState?.reset();
    }
  } catch (e) {
    _formKey.currentState?.reset();
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      text: "You can't invite yourself!",
      confirmBtnColor: const Color(0xff7b39ed),
    );
  }
  _typeAheadController.clear();
}





  @override
  Widget build(BuildContext context) {
    InvitaitonProvider provider = Provider.of<InvitaitonProvider>(context);
    String name = "";
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeAheadController,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (val) {
                    query = val.toLowerCase();
                    provider.filterEmail(query);
                  }),
              suggestionsCallback: (pattern) {
                print('changing');
                return provider.filteredEmails;
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.toString()),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._typeAheadController.text = suggestion.toString();
                email = suggestion.toString();
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                }
              },
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          ElevatedButton(
            onPressed: () async {
              String recieverEmail = email.toString();
              final _firebaseFirestore = FirebaseFirestore.instance;
              final senderEmail = _firebaseAuth.currentUser?.email;

              /*final res = await _firebaseFirestore
                  .collection('invitations')
                  .where("recieverEmail", isEqualTo: recieverEmail)
                  .where("senderEmail", isEqualTo: senderEmail)
                  .where("listId", isEqualTo: widget.listId)
                  .get();*/
              final res = await _firebaseFirestore
                  .collection('invitations')
                  .where("recieverEmail", isEqualTo: recieverEmail)
                  .where("senderEmail", isEqualTo: senderEmail)
                  .where("listId", isEqualTo: widget.listId)
                  .where("status", isEqualTo: "pending")
                  .get();

              //Case1 pending
              if (res.docs.isNotEmpty) {
                print("helloooooooo");
                print("dublicate00");
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.error,
                  title: "Invitation",
                  text: "The invitation has already been sent",
                  confirmBtnColor: const Color(0xff7b39ed),
                );
                _typeAheadController.clear();
              } else {
                final res1 = await _firebaseFirestore
                    .collection('invitations')
                    .where("recieverEmail", isEqualTo: recieverEmail)
                    .where("senderEmail", isEqualTo: senderEmail)
                    .where("listId", isEqualTo: widget.listId)
                    .where("status", isEqualTo: "accepted")
                    .get();

                //Case2 accepted
                if (res1.docs.isNotEmpty) {
                  print("accepted");
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    title: "Invitation",
                    text: "Friend already has this list!",
                    confirmBtnColor: const Color(0xff7b39ed),
                  );
                }
                //case3+4 Fisrt Time or rejected
                else {
                  await sendInviation(query, widget.listId);
                  getUsersToken(email.toString());
                }
              }
              _typeAheadController.clear();
            },
            child: const Text(
              'Invite',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.grey.shade600,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Util.routeToWidget(context, NavBar(tabs: 0));
                  },
                  child: const Text(
                    'Later',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      {VoidCallback? onTap, required String text, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MaterialButton(
        color: color,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

 Future<void> sendNotification(String title, String token) async {
  print('dalal');
  print('raghad');

  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAArqJFQfk:APA91bFyFdlX-dk-72NHyaoN0hb4xsp8wuDUhr63ZgI7vroxRSBX1mXbd2pASgdzoYKA_8A0ZYRw61GzRaIH_6eakiVtyr_X8FJrlax-HwJdSUzbk022EGjfVjkDo7dlgYZNXaMfJS4T'
  };

  final body = jsonEncode(<String, dynamic>{
    'notification': <String, dynamic>{
      'title': title,
      'body': 'You got invitations from your friend to his list!!'
    },
    'priority': 'high',
    'data': data,
    'to': token,
  });

  try {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print("Error sending notification");
    }
  } catch (e) {
    print("Error: $e");
  }
}





  Future getUsersToken(String receiver) async {
    print('hello');
    final currentUserEmail = _firebaseAuth.currentUser?.email;
    final sendEmail = '';

    final res = await _firebaseFirestore
        .collection('users1')
        .where("email", isNotEqualTo: currentUserEmail)
        .get();
    if (res.docs.isNotEmpty) {
      for (int i = 0; i < res.docs.length; i++) {
        if (res.docs[i]['email'] == receiver) {
          print('raghad');
          print(res.docs[i]['token']);
          print('raghad');
          final String receivertoken = res.docs[i]['token'];
          sendNotification('New Invitation', receivertoken);
        }
      }
    }
  }

  checkNotDub(String recieverEmail, String listId) async {
    final _firebaseFirestore = FirebaseFirestore.instance;
    final senderEmail = _firebaseAuth.currentUser?.email;

    print(recieverEmail);
    print(listId);

    final res = await _firebaseFirestore
        .collection('invitations')
        .where("recieverEmail", isEqualTo: recieverEmail)
        .where("senderEmail", isEqualTo: senderEmail)
        .where("listId", isEqualTo: listId)
        .get();

    if (res.docs.isNotEmpty) {
      print("helloooooooo");
      print("dublicate00");
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "You can't send same invitation twice!",
        confirmBtnColor: const Color(0xff7b39ed),
      );
    } else {
      return false;
    }
  }
}
