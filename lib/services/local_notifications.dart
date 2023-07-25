import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin localNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            defaultPresentSound: true,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await localNotificationPlugin.initialize(
      initializationSettings,
    );
    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));

    localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel Id', 'channel Name',
          importance: Importance.max),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    );
  }

  static showNotification({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    await localNotificationPlugin.show(id, title, body, _notificationDetails());
  }

  static Future<void> cancelNotification(int id) async {
    await localNotificationPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await localNotificationPlugin.cancelAll();
  }

  static scheduledNotification({
    required String title,
    required String body,
    required DateTime date,
    int id = 1,
    String? payload,
  }) async {
    // await localNotificationPlugin.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   tz.TZDateTime.from(date, tz.local),
    //   _notificationDetails(),
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.wallClockTime,
    //   androidAllowWhileIdle: true,
    // );
  }
}
