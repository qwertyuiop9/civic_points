import 'Notification_Service.dart';

class NotificationHandler {
  final NotificationService notifications = NotificationService();

  // schedule notification
  void scheduleNotification() {
    this.notifications.notifyMe();
  }

  void cancelNotification(int myID) {
    this.notifications.deleteNotification(myID);
  }
}

NotificationHandler nh = NotificationHandler();
