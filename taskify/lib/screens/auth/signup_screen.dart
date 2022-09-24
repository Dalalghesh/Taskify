import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/util.dart';
import 'package:taskify/utils/validators.dart';
import 'package:taskify/widgets/primary_button.dart';
import 'package:taskify/widgets/primary_text_field.dart';
import 'package:taskify/widgets/titled_drop_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/platform_dialogue.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String gender = "Male";

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  String get firstname => _firstnameController.text.trim();
  String get lastName => _lastnameController.text.trim();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Util.routeToWidget(context, LoginScreen());
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                //padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/login.jpeg",
                        height: 250,
                        width: 250,
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  //  const SizedBox(height: 24),
                  PrimaryTextField(
                    title: "First Name",
                    hintText: "First Name",
                    textInputAction: TextInputAction.next,
                    controller: _firstnameController,
                    validator: Validators.emptyValidator,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    title: "Last Name",
                    hintText: "Last Name",
                    textInputAction: TextInputAction.next,
                    validator: Validators.emptyValidator,
                    controller: _lastnameController,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    title: "Email",
                    hintText: "Must be gmail address",
                    textInputAction: TextInputAction.next,
                    // validator: Validators.emptyValidator,
                    validator: Validators.emailValidator,

                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    controller: _passwordController,
                    title: "Password",
                    hintText: "At least 8 Character",
                    obscureText: true,
                    validator: Validators.passwordValidator,
                  ),
                  const SizedBox(height: 16),
                  TitledDropDown<String?>(
                    items: const ['Male', 'Female'],
                    titles: const ['Male', 'Female'],
                    value: gender,
                    title: "Gender",
                    hint: "Select Gender",
                    onChanged: (value) {
                      gender = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    disabled: isLoading,
                    onTap: () {
                      if (!formKey.currentState!.validate()) return;
                      FocusScope.of(context).unfocus();
                      registerWithEmailAndPassword(
                          firstname, lastName, gender, email, password);
                    },
                    text: isLoading ? "Loading ..." : 'Sign Up',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                            children: const [
                              TextSpan(
                                text: "Log in",
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

  Future<void> registerWithEmailAndPassword(
    String firstname,
    String lastname,
    String gender,
    String email,
    String password,
  ) async {
    isLoading = true;
    setState(() {});
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final name = "$firstname $lastname";
      //Creating username from firstname and last name
      //Lowercase all the chracters and remove spaces inbetween first name and lastname
      final username =
          name.split('').map((e) => e.toLowerCase()).join().replaceAll(" ", "");
      await userCredential.user!.updateDisplayName(name);
      final uid = userCredential.user!.uid;
      final userData = {
        'email': email,
        'firstName': firstname,
        'lastName': lastName,
        'gender': gender,
        'username': username,
        'categories': <Map>[],
        'uid': userCredential.user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await docRef.set(userData, SetOptions(merge: true));
      isLoading = false;
      setState(() {});
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }));
    } catch (e) {
      isLoading = false;
      setState(() {});
      showExceptionDialog(context, e);
    }
  }
}
