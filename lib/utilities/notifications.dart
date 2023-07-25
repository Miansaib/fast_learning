import '../services/local_notifications.dart';

class Notifications {
  static appLastOpened() async {
    LocalNotifications.cancelNotification(1);
    LocalNotifications.scheduledNotification(
      title: 'Reminder',
      body: 'You didn\'nt Read any lessons since yesterday',
      date: DateTime.now().add(
        Duration(minutes: 1),
      ),
    );
  }
}
