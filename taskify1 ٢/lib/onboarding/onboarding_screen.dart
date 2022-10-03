import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/homePage.dart';

import '../screens/auth/login_screen.dart';
import '../screens/ProfileScreen/profileScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController pagecontroller;
  final indexNotifier = ValueNotifier<int>(0);
  @override
  void initState() {
    pagecontroller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pagecontroller,
                  onPageChanged: (value) => indexNotifier.value = value,
                  itemCount: contents.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(contents[index].imageName ?? ""),
                            width: 340,
                            height: 340,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            contents[index].title ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                            ),
                            //  Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            contents[index].description ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            //    style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(contents.length, (index) {
                  return ValueListenableBuilder(
                      valueListenable: indexNotifier,
                      builder: (context, currentIndex, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 8,
                          width: currentIndex == index ? 50 : 25,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 3,
                              )
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: currentIndex == index
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        );
                      });
                }),
              ),
              const SizedBox(height: 24.0),
              ValueListenableBuilder<int>(
                valueListenable: indexNotifier,
                builder: (context, index, child) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    width: size.width * 0.9,
                    height: size.height * 0.1,
                    child: ElevatedButton(
                      onPressed: () {
                        if (index == 2) {
                          final screenToOpen =
                              FirebaseAuth.instance.currentUser == null
                                  ? const LoginScreen()
                                  : NavBar(
                                      tabs: 0,
                                    );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => screenToOpen,
                            ),
                          );
                          return;
                        }
                        pagecontroller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Text(
                        style: TextStyle(fontSize: 18),
                        index == contents.length - 1 ? "Continue" : "Next",
                        //  style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<IntroContent> contents = [
  IntroContent(
      imageName: "assets/images/taking-notes-amico.png",
      title: "\nCreate Your Task",
      description:
          "Add your task to ensure that every task you have is completed on time"),
  IntroContent(
      imageName: "assets/images/to-do-list-cuate.png",
      title: "\nManage your Daily Task",
      description:
          "By using this application you will be able to manage your daily tasks"),
  IntroContent(
    imageName: "assets/images/writing-a-letter-rafiki.png",
    title: "\nChecklist Finished Task",
    description:
        "If you complete your task, you can view your work result every day",
  )
];

class IntroContent {
  String? imageName, title, description;

  IntroContent(
      {required this.imageName,
      required this.title,
      required this.description});
}
