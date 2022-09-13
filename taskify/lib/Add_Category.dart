
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:taskify/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cool_alert/cool_alert.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Add_Category());
}

Widget build(BuildContext context) {
  return MaterialApp(
    home: Add_Category(),
  );
}

class Add_Category extends StatefulWidget {
  @override
  _Add_Category createState() => _Add_Category();
}
  late String? Category; 

  

class _Add_Category extends State<Add_Category> {
  //const SendInstructionsView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>(); //key for form
  final _firestore = FirebaseFirestore.instance;
  
void getCategory() async{
  final Categorys = await _firestore.collection('Category').get();
  for (var Category in  Categorys.docs){
 print(Category.data());
  }
}
// puch notifications
 void initState(){
  super.initState();
  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessage.listen((event) {
    print('FCM ,Message received');
  });
  //storeNotificationToken();
 }

 /*bool isLoding = false;
 
 storeNotificationToken()async{
  String? token = await FirebaseMessaging.instance.getToken();
  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(
    {
      'token':token
    },SetOptions(merge: true));
 }*/
  
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {}, // home page
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey, //key for form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Category',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Image.asset(
              'assets/Category.png',
                      height: 200,
                      width: 200,
                    )),
                SizedBox(
                  height: 16,
                ),

                //-----------------------Category name-----------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    'Category Name:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                onChanged: (value) {
                  Category =value;
                },
                    decoration: InputDecoration(
                      hintText: 'Ex: Work',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Please enter Category name";
                      else
                        return null;
                    },
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        
                       //print(Category);
                    
                        //navigate to check email view
                        if (formKey.currentState!.validate()) {
                           CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Created successfully",
                            confirmBtnColor: const Color(0xff7b39ed),
                           // onConfirmBtnTap: () => route(isChecked),
                          );

                                 _firestore.collection('Category').add({
                                 'Name': Category!,
                       }
                       );


                          //Util.routeToWidget(context, InviteFriend());
                          //_scaffoldKey.currentState!.showSnackBar(snackBar);
                        }
                        //getCategory(); 
                      },
                      child: Text(
                        'Create',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                    
                  ],
                ),
              ],
            ),
          ),
        )
        );

  }
}