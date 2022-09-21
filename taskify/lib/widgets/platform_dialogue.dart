import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showPlatformDialogue({
  required BuildContext context,
  required String title,
  Widget? content,
  String? action1Text,
  bool? action1OnTap,
  String? action2Text,
  bool? action2OnTap,
}) async {
  showDialog(
      context: context,
      builder: (context) {
        return (Platform.isAndroid)
            ? AlertDialog(
                title: Text(title),
                content: content,
                actions: <Widget>[
                  if (action2Text != null && action2OnTap != null)
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(action2OnTap),
                      child: Text(action2Text),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(action1OnTap),
                    child: Text(action1Text ?? 'OK'),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                content: content,
                title: Text(title),
                actions: <Widget>[
                  if (action2Text != null && action2OnTap != null)
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(action2OnTap),
                      child: Text(action2Text),
                    ),
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(action1OnTap),
                    child: Text(action1Text ?? 'OK'),
                  ),
                ],
              );
      });
  return null;
}

void showExceptionDialog(BuildContext context, dynamic e) {
  if (e is SocketException) {
    showPlatformDialogue(
      context: context,
      title: 'Network Error',
      content: const Text("Seems like, you're not connected to internet"),
    );
    return;
  }
  if (e is FirebaseAuthException) {
    if (e.code == 'user-not-found') {
      showPlatformDialogue(
        context: context,
        title: 'User Not Found',
        content: const Text('No user correspond to this email. Try signing up.'),
      );
    } else if (e.code == 'operation-not-allowed') {
      showPlatformDialogue(
        context: context,
        title: 'Provider not enabled',
        content: const Text('Sign in method not enabled in firebase console.'),
      );
    } else if (e.code == 'internal-error') {
      showPlatformDialogue(
        context: context,
        title: 'Internal Error',
        content: const Text(
          'Firebase Authentication not enabled in firebase console.',
        ),
      );
    } else if (e.code == 'wrong-password') {
      showPlatformDialogue(
        context: context,
        title: 'Wrong Password',
        content: const Text(
          'The entered password is incorrect. Please try with correct password or try resetting password.',
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      showPlatformDialogue(
        context: context,
        title: 'Email already in use',
        content: const Text(
          'This email is already in use by another provider. Please sign in with correct provider.',
        ),
      );
    } else {
      showPlatformDialogue(
        context: context,
        title: 'Error',
        content: Text(e.message?.toString() ?? 'Unknown Error'),
      );
    }

    return;
  }

  log(e.runtimeType.toString(), name: 'showExceptionDialog');
  showPlatformDialogue(
    context: context,
    title: 'Error',
    content: Text(e.toString()),
  );
}
