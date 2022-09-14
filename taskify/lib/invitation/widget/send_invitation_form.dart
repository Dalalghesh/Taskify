import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/authentication/screens/login_screen.dart';

import '../../authentication/widgets/platform_dialogue.dart';
import '../../utils/validators.dart';
import '../provider/invitation.dart';
import '../screens/received_invitations.dart';

class SendInvitationForm extends StatefulWidget {
  const SendInvitationForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SendInvitationForm> createState() => _SendInvitationFormState();
}

class _SendInvitationFormState extends State<SendInvitationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  Future<void> sendInviation() async {
    try {
      final validate = _formKey.currentState?.validate();
      if (validate ?? false) {
        _formKey.currentState?.save();
        await context.read<InvitaitonProvider>().sendInvitation(email!);
        showPlatformDialogue(
            context: context, title: "Invitation sent successfully");
        _formKey.currentState?.reset();
      }
    } catch (e) {
      _formKey.currentState?.reset();
      showPlatformDialogue(context: context, title: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Ex: Sara@gmail.com',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
                validator: (value) => Validators.emailValidator(value),
                onSaved: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.black)),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () async => await sendInviation(),
            child: const Text(
              'Invite',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(RecievedInvitations.routeName);
            },
            child: const Text("Check your invitations"),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
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
          ),
        ],
      ),
    );
  }
}
