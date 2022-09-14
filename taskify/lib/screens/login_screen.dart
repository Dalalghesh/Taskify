import 'package:taskify/screens/create_new_password_view.dart';
import 'package:taskify/screens/home_screen.dart';
import 'package:taskify/screens/send_instructions_view.dart';
import 'package:taskify/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/util.dart';
import '../widgets/custom_header.dart';
import '../widgets/platform_dialogue.dart';
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
      appBar: AppBar(
        leadingWidth: 50,
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
                    'Sign In',
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
                  Text(
                    'Email address:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Ex: John@gmail.com',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                      ),
                      controller: _emailController,
                      validator: Validators.emailValidator,
                      textInputAction: TextInputAction.next,

                      // autofillHin: "Enter Email",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Password:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'At least 8 Character',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                      ),
                      controller: _emailController,
                      maxLines: 1,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: Validators.passwordValidator,
                      // hintText: "At least 8 Character",
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SendInstructionsView(),
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
                              color: Color(0xff7b39ed).withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
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
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                            children: const [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: Color(0xff7b39ed),
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
        return const HomeScreen();
      }));
    } catch (e) {
      isLoading = false;
      setState(() {});
      showExceptionDialog(context, e);
    }
  }
}
