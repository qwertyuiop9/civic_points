import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  //
  //
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  //
  //
  Future selectNotification(String payload) async {}

  //--------------------------------------
  // Custom methods for notifications ----
  //--------------------------------------
  //--
  //--

  //  @Input:   int timestamp in millisecondsSinceEpoch, int note ID, String title of a note, String content of a note, optional String repetition type
  //  @result:  schedules a notification for a certain date and time
  //
  Future<void> notifyMe() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Ruolo sindaco',
      'Canale ruolo sindaco',
      'Canale cambio ruolo in sindaco',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Promozione ruolo',
      'Sei stato promosso a sindaco!',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  //  @input:   int note ID
  //  @result:  cancel a scheduled notification
  //
  Future<void> deleteNotification(int noteID) async {
    await flutterLocalNotificationsPlugin.cancel(noteID);
  }
} // Class NotificationService
