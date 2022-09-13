import 'package:faay/utils/validators.dart';
import 'package:faay/widgets/primary_button.dart';
import 'package:faay/widgets/primary_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/platform_dialogue.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  String get email => _emailController.text.trim();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.deepPurple,
          ),
          const SafeArea(child: CustomHeader(text: 'Forgot Password.')),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.135),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.whiteshade,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(child: Image.asset("assets/images/login.jpeg")),
                  ),
                  const SizedBox(height: 24),
                  PrimaryTextField(
                    controller: _emailController,
                    title: "Email",
                    hintText: "Enter Email",
                    validator: Validators.emailValidator,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    disabled: isLoading,
                    text: isLoading ? "Loading ..." : 'Send Password Reset Link',
                    onTap: () async {
                      if (!formKey.currentState!.validate()) return;
                      FocusScope.of(context).unfocus();
                      await showPlatformDialogue(
                        context: context,
                        title: 'Email Sent',
                        content: const Text('Please check your inbox to reset email'),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> passwordReset(String email) async {
    isLoading = true;
    setState(() {});
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await showPlatformDialogue(
        context: context,
        title: 'Email Sent',
        content: const Text('Please check your inbox to reset email'),
      );
      isLoading = false;
      setState(() {});
      Navigator.of(context).pop();
    } catch (e) {
      isLoading = false;
      setState(() {});
      showExceptionDialog(context, e);
    }
  }
}
