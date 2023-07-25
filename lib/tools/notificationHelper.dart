// import 'package:Fast_learning/model/ReminderNotification.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// final BehaviorSubject<ReminderNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReminderNotification>();

// final BehaviorSubject<String> selectNotificationSubject =
//     BehaviorSubject<String>();

// Future<void> initNotifications(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//   var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//   var initializationSettingsIOS = IOSInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//       onDidReceiveLocalNotification:
//           (int? id, String? title, String? body, String? payload) async {
//         didReceiveLocalNotificationSubject.add(ReminderNotification(
//             id: id, title: title, body: body, payload: payload));
//       });

//   final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onSelectNotification: ((payload) {
//       // String? payload = details.payload;

//       if (payload != null) {
//         debugPrint('notification payload: ' + payload);
//       }
//       selectNotificationSubject.add(payload!);
//     }),
//     //  onDidReceiveBackgroundNotificationResponse: ((details) {
//     //   String? payload = details.payload;

//     //   if (payload != null) {
//     //     debugPrint('notification payload: ' + payload);
//     //   }
//     //   selectNotificationSubject.add(payload!);
//     // }),
//   );
// }

// Future<void> showNotification(
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//   String body,
// ) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'Reminder notifications',
//     'Remember about it',
//     icon: 'app_icon',
//   );
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       0, 'Reminder', body, platformChannelSpecifics);
// }

// Future<void> scheduleNotification(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//     String id,
//     String body,
//     DateTime scheduledNotificationDateTime) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     id,
//     'Remember about it',
//     icon: 'app_icon',
//   );
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);
//   // await flutterLocalNotificationsPlugin.schedule(0, 'Reminder', body,
//   //     scheduledNotificationDateTime, platformChannelSpecifics);

//   tz.initializeTimeZones();
// // tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
//   var currentDateTime =
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1));
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     'Reminder',
//     body,
//     currentDateTime,
//     platformChannelSpecifics,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//     androidAllowWhileIdle: true,
//   );
// }

// Future<void> scheduleNotificationPeriodically(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//     int id,
//     String title,
//     String body,
//     RepeatInterval interval) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     id.toString(),
//     'Reminder notifications',
//     icon: 'smile_icon',
//   );
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);
//   // await flutterLocalNotificationsPlugin.periodicallyShow(
//   //     0, 'Reminder', body, interval, platformChannelSpecifics);
//   flutterLocalNotificationsPlugin.periodicallyShow(
//       id, title, body, interval, platformChannelSpecifics,
//       androidAllowWhileIdle: true);
// }

// void requestIOSPermissions(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           IOSFlutterLocalNotificationsPlugin>()
//       ?.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
// }
