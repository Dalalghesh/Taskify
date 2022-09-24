import 'package:taskify/homePage.dart';
import 'package:taskify/screens/ProfileScreen/profileScreen.dart';
import 'package:taskify/utils/validators.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:taskify/widgets/primary_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/send_instructions/send_instructions_view.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/platform_dialogue.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
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
          const SafeArea(child: CustomHeader(text: 'Log In.')),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.135),
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
                    child:
                        Center(child: Image.asset("assets/images/login.jpeg")),
                  ),
                  const SizedBox(height: 24),
                  PrimaryTextField(
                    controller: _emailController,
                    title: "Email",
                    hintText: "Enter Email",
                    validator: Validators.emailValidator,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    validator: Validators.passwordValidator,
                    title: "Password",
                    maxLines: 1,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    hintText: "At least 8 Character",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SendInstructionsView(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: AppColors.deepPurple.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PrimaryButton(
                    disabled: isLoading,
                    text: isLoading ? "Loading ..." : 'Sign In',
                    onTap: () {
                      if (!formKey.currentState!.validate()) return;
                      FocusScope.of(context).unfocus();
                      loginWithEmailAndPassword(email, password);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.deepPurple.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                            children: const [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: AppColors.deepPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    isLoading = true;
    setState(() {});

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      setState(() {});
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return NavBar(tabs: 0);
      }));
    } catch (e) {
      isLoading = false;
      setState(() {});
      showExceptionDialog(context, e);
    }
  }
}
