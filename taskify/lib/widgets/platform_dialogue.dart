import 'dart:developer';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
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
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      text: "Seems like, you're not connected to internet",
      confirmBtnColor: const Color(0xff7b39ed),
    );

    return;
  }
  if (e is FirebaseAuthException) {
    if (e.code == 'user-not-found') {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "No user correspond to this email. Try signing up.",
        confirmBtnColor: const Color(0xff7b39ed),
      );
    } else if (e.code == 'operation-not-allowed') {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Sign in method not enabled in firebase console.'",
        confirmBtnColor: const Color(0xff7b39ed),
      );
      showPlatformDialogue(
        context: context,
        title: 'Provider not enabled',
        content: const Text('Sign in method not enabled in firebase console.'),
      );
    } else if (e.code == 'internal-error') {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Firebase Authentication not enabled in firebase console.",
        confirmBtnColor: const Color(0xff7b39ed),
      );
    } else if (e.code == 'wrong-password') {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text:
            "The entered password is incorrect. Please try with correct password or try resetting password.",
        confirmBtnColor: const Color(0xff7b39ed),
      );
    } else if (e.code == 'email-already-in-use') {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text:
            "This email is already in use by another user. Please sign in with correct user.",
        confirmBtnColor: const Color(0xff7b39ed),
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: e.message?.toString() ?? 'Unknown Error',
        confirmBtnColor: const Color(0xff7b39ed),
      );
    }

    return;
  }

  log(e.runtimeType.toString(), name: 'showExceptionDialog');
  CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    text: e.toString(),
    confirmBtnColor: const Color(0xff7b39ed),
  );
}
