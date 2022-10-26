import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/onboarding/onboarding_screen.dart';
import 'package:taskify/util.dart';
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
import 'package:workmanager/workmanager.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Util.routeToWidget(context, OnboardingScreen());
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'Email:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "John@gmail.com",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    validator: Validators.emailValidator,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'Password:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  TextFormField(
                    validator: Validators.passwordValidator,
                    maxLines: 1,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "At least 8 Character",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
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
                              color: AppColors.deepPurple,
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
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
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
              print("loged in1");
            Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
            var time = DateTime.now().second.toString();
            Workmanager().registerPeriodicTask(time,'firstTask' , frequency: const Duration(minutes: 15));
            print("loged in2");
        return NavBar(tabs: 0);
              
      }));
    } catch (e) {
      isLoading = false;
      setState(() {});
      showExceptionDialog(context, e);
    }
  }
}

void callbackDispatcher(){
  print("inside callbackDispatcher login");
  print("ddddddddddddddddaa");
Workmanager().executeTask((taskName, inputData)async{
print("inside callbackDispatcher executeTask login1");
print("inside callbackDispatcher executeTask login2");
print("inside callbackDispatcher executeTask login3");
return Future.value(true);
});
}
