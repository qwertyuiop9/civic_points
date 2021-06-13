import 'notificationService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  final NotificationService notifications = NotificationService();

  // schedule notification
  void scheduleNotification(RemoteMessage message) {
    this.notifications.notifyMe(message);
  }

  void cancelNotification(int myID) {
    this.notifications.deleteNotification(myID);
  }
}

NotificationHandler nh = NotificationHandler();
