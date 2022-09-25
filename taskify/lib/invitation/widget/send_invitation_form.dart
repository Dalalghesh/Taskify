import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:taskify/homePage.dart';

import 'package:taskify/screens/AddList.dart';

import '../../util.dart';
import '../../utils/validators.dart';
import '../provider/invitation.dart';
import '../screens/received_invitations.dart';
import 'package:cool_alert/cool_alert.dart';

class SendInvitationForm extends StatefulWidget {
  String category;
  String list;
  SendInvitationForm({Key? key, required this.category, required this.list})
      : super(key: key);

  @override
  State<SendInvitationForm> createState() => _SendInvitationFormState();
}

class _SendInvitationFormState extends State<SendInvitationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String query = '';
  String? email;
  Future<void> sendInviation() async {
    try {
      final validate = _formKey.currentState?.validate();
      if (validate ?? false) {
        _formKey.currentState?.save();
        print(email.toString());
        await context
            .read<InvitaitonProvider>()
            .sendInvitation(email!, widget.category, widget.list);
        // Provider.of<InvitaitonProvider>(context, listen: false).selectedUser(email);
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Invitation sent successfully",
          confirmBtnColor: const Color(0xff7b39ed),
          // onConfirmBtnTap: () => route(isChecked),
        );
        // showPlatformDialogue(
        //     context: context, title: "Invitation sent successfully");
        _formKey.currentState?.reset();
      }
    } catch (e) {
      _formKey.currentState?.reset();
      //showPlatformDialogue(context: context, title: e.toString());
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "A user with that email does not exists",
        confirmBtnColor: const Color(0xff7b39ed),
        // onConfirmBtnTap: () => route(isChecked),
      );
    }
    _typeAheadController.clear();
  }
  // List<String> emails = [];

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
                    query = val;
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
              //   onSaved: (value) => this._selectedCity = value,
            ),

            // TextFormField(
            //     decoration: InputDecoration(
            //       hintText: 'Ex: John@gmail.com',
            //       contentPadding: EdgeInsets.symmetric(
            //         vertical: 10,
            //         horizontal: 10,
            //       ),
            //     ),
            //     validator: (value) => Validators.emailValidator(value),
            //     onSaved: (value) {
            //       email = value;
            //     },
            //      onChanged: (val) {
            //   setState(() {
            //     name = val;
            //     print(name);
            //   });
            //
            // },
            //     keyboardType: TextInputType.emailAddress,
            //     textInputAction: TextInputAction.done,
            //     style: Theme.of(context)
            //         .textTheme
            //         .subtitle1
            //         ?.copyWith(color: Colors.black)),
            //
          ),
          const SizedBox(
            height: 0,
          ),
          ElevatedButton(
            onPressed: () async => await sendInviation(),
            child: const Text(
              'Invite',
              style: TextStyle(fontSize: 20),
            ),
          ),
          // const SizedBox(
          //   height: 16,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).pushNamed(RecievedInvitations.routeName);
          //   },
          //   child: const Text("Check your invitations"),
          // ),
          const SizedBox(
            height: 5,
          ),
          /* GestureDetector(
                onTap: () {
                  try {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  } catch (e) {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  }
                },
                child: const Text("Logout"),
              ),*/
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
                  child: const Text('Later'),
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
}
