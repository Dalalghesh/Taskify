
// ignore_for_file: unused_local_variable

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotificationService{
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> inialize() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@drawable/ic_stat_person_add.png');
    
    final InitializationSettings settings = InitializationSettings(
       android: androidInitializationSettings,
     );

final InitializationSettings settings = InitializationSettings(android: androidInitializationSettings,);    

await _localNotificationService.initialize(
       settings,
       onSelectNotification: onSelectNotification,
     );
  }

  void onSelectNotification(String? playload){
    
  }
}