import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:taskify/homePage.dart';
import 'package:taskify/screens/AddList.dart';
import 'package:taskify/service/local_push_notification.dart';
import '../../util.dart';
import '../../utils/validators.dart';
import '../provider/invitation.dart';
import '../screens/received_invitations.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;

class SendInvitationForm extends StatefulWidget {
  String category;
  String list;
   SendInvitationForm({
    Key? key,
    required this.category,
    required this.list
  }) : super(key: key);

  @override
  State<SendInvitationForm> createState() => _SendInvitationFormState();
}

class _SendInvitationFormState extends State<SendInvitationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String query ='';
  String? email;

   void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    //storenotificationToken();

    FirebaseMessaging.instance.subscribeToTopic('subscription');
   sendNotification('New Invitation', 'cJt964VuQXCP2SdkKGeMBP:APA91bF0t8wtgylAXoaxsw_VIfcGsCA-uMPHqiGATtUn6yrvl3H5l6cI9nx_CUztj-pLDnOjdUpjno-0JwgZE0bwirV4xyq88KPOmXGcJ9NYsEvRgSstlXYu5r7lMR6r_-CZZAz17RpD');
    }
    
      sendNotification(String title, String token)async{

    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try{
     http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAArqJFQfk:APA91bFyFdlX-dk-72NHyaoN0hb4xsp8wuDUhr63ZgI7vroxRSBX1mXbd2pASgdzoYKA_8A0ZYRw61GzRaIH_6eakiVtyr_X8FJrlax-HwJdSUzbk022EGjfVjkDo7dlgYZNXaMfJS4T'
      },
      body: jsonEncode(<String,dynamic>{
        'notification': <String,dynamic> {'title': 'You received new invitiation!','body': 'You received new invitiation!'},
        'priority': 'high',
        'data': data,
        // token of user will receive the notification 
        'to': '$token'
      })
      );


     if(response.statusCode == 200){
       print(" notificatin is sended");
     }else{
       print("Error");
     }

    }catch(e){

    }

  }

    
  Future<void> sendInviation() async {

    //calling to create token 
    //storenotificationToken();

    try {
      final validate = _formKey.currentState?.validate();
      if (validate ?? false) {
        _formKey.currentState?.save();
        print(email.toString());
        await context.read<InvitaitonProvider>().sendInvitation(email!, widget.category, widget.list);
       // Provider.of<InvitaitonProvider>(context, listen: false).selectedUser(email);
         CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Invitation sent successfully",
                            confirmBtnColor: const Color(0xff7b39ed),
                           // onConfirmBtnTap: () => route(isChecked),
                          );
        // showPlatformDialogue(
        //     context: context, title: "Invitation sent successfully");
        _formKey.currentState?.reset();
      }
    } catch (e) {
      _formKey.currentState?.reset();
      //showPlatformDialogue(context: context, title: e.toString());
      CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text: "A user with that email does not exists",
                            confirmBtnColor: const Color(0xff7b39ed),
                           // onConfirmBtnTap: () => route(isChecked),
                          );
    }
    _typeAheadController.clear();
  }
 // List<String> emails = [];

  @override
  Widget build(BuildContext context) {
    InvitaitonProvider provider = Provider.of<InvitaitonProvider>(context);
     String name = "";
    return  Form(

          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController,
                      decoration: InputDecoration(
                          labelText: 'Email'
                      ),
                    onChanged: (val){
                        query = val;
                        provider.filterEmail(query);
                    }
                  ),
                  suggestionsCallback: (pattern) {
                    print('changing');
                    return provider.filteredEmails;
                  },

                  itemBuilder: (context, suggestion) {

                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController.text = suggestion.toString();
                    email = suggestion.toString();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    }
                  },
               //   onSaved: (value) => this._selectedCity = value,
                ),
                ),

              const SizedBox(
                height: 0,
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
          
              Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.grey.shade600,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          Util.routeToWidget(context, NavBar(tabs: 0));
                        },
                        child: const Text('Later'),

                      ),
                    ),
                  ],
                ),
            ],
          ),
        );

  }
  Widget _buildButton(
      {VoidCallback? onTap, required String text, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MaterialButton(
        color: color,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  //change place later 
  storenotificationToken()async{
    //get notifiaction token for ourself
    String? token =await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users1').doc(FirebaseAuth.instance.currentUser!.uid).set(
      {
        'token':token
      },SetOptions(merge: true));
  }

}
