

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotificationService{
  static Future initializ (FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin)async{
    var androidInitializ = new AndroidInitializationSettings('drawable-hdpi/ic_stat_person_add.png');
   // var iOSInitializ = new IOSInitializationSettings();
    var initializtionSettings = new InitializationSettings(android: androidInitializ);  
    //,iOS: iOSInitializ);
    await flutterLocalNotificationsPlugin.initialize(initializtionSettings);

  }

  
}