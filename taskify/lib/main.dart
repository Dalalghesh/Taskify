import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:provider/provider.dart';
import 'package:taskify/appstate.dart';
import 'package:taskify/invitation/provider/invitation.dart';
import 'package:taskify/send_instructions/send_instructions_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskify/service/local_push_notification.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'Util.dart';
import 'firebase_options.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

import 'package:taskify/onboarding/onboarding_screen.dart';

import 'homePage.dart';
import 'util.dart';
import 'package:cron/cron.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:workmanager/workmanager.dart';
// #7b39ed - primary color

/*void callbackDispatcher(){
Workmanager().executeTask((taskName, inputData){
print("inside callbackDispatcher main");
return Future.value(true);
});
}*/

Future<void> main() async {
  ///add subtask here
  ///

  WidgetsFlutterBinding.ensureInitialized();
/*print("inside main befor calling");
  Workmanager().initialize(callbackDispatcher);
  print("inside main after calling");*/

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var _clientID = new ClientId(Secret.getId(), "");
  const _scopes = const [cal.CalendarApi.calendarScope];
  LocalNotificationService.initialize();
  // await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) async {
  //    CalendarClient.calendar = cal.CalendarApi(client);
  //  });

  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: Color(0xff7b39ed),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true)
      ]);
  runApp(MyApp());
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void initState() {
  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessage.listen((event) {
    LocalNotificationService.display(event);
  });

  FirebaseMessaging.instance.subscribeToTopic('subscription');
}

class MyApp extends StatelessWidget {
  final MaterialColor primarySwatch = MaterialColor(0xff7b39ed, <int, Color>{
    50: Color(0xff7b39ed),
    100: Color(0xff7b39ed),
    200: Color(0xff7b39ed),
    300: Color(0xff7b39ed),
    400: Color(0xff7b39ed),
    500: Color(0xff7b39ed),
    600: Color(0xff7b39ed),
    700: Color(0xff7b39ed),
    800: Color(0xff7b39ed),
    900: Color(0xff7b39ed),
  });

  initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage:$message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      // Navigator.of(context).pushNamed("ReceivedInvitation");
      //Util.routeToWidget(context, NavBar(tabs: 0));
    });
  }

  void initState() {
    initNotification();
    // TODO: implement initState
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    FirebaseMessaging.instance.subscribeToTopic('subscription');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InvitaitonProvider())
      ],
      child: ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            iconTheme: IconThemeData(color: Color(0xff7b39ed)),
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
            textTheme: TextTheme(
                headline4:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                subtitle1: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                )),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black)),
            primaryColor: Color(0xff7b39ed),
            primarySwatch: primarySwatch,
          ),
          home: OnboardingScreen(),
        ),
      ),
    );
  }
}

class Secret {
  static const ANDROID_CLIENT_ID =
      "750046757369-80s1uahk2ljsin59u7rbctgvt2vi9q0f.apps.googleusercontent.com";
  static const IOS_CLIENT_ID =
      "750046757369-igku66q499v27k16qnjr1p7vrvppgi85.apps.googleusercontent.com";
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}

class CalendarClient {
  // For storing the CalendarApi object, this can be used
  // for performing all the operations
  static var calendar;

  // For creating a new calendar event
  insert({
    required String title,
    required String description,
    required String location,
    required List<cal.EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    required bool hasConferenceSupport,
    required DateTime startTime,
    required DateTime endTime,
  }) async {}
}

// For patching an already-created calendar event
modify({
  required String id,
  required String title,
  required String description,
  required String location,
  required List<cal.EventAttendee> attendeeEmailList,
  required bool shouldNotifyAttendees,
  required bool hasConferenceSupport,
  required DateTime startTime,
  required DateTime endTime,
}) async {}

// For deleting a calendar event
Future<void> delete(String eventId, bool shouldNotify) async {}

void Notify() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'Deadline Coming soon!',
          body: 'body text/ content, i will come later'));
}
