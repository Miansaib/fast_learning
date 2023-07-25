import 'package:Fast_learning/services/local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebasePushNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FirebasePushNotification instance = FirebasePushNotification();

  Future<void> init() async {
    final NotificationSettings? settings = await _requestPermission();
    print(settings?.authorizationStatus);
    _registerForegroundMessageHandler();

    if (settings == null ||
        (settings.authorizationStatus != AuthorizationStatus.provisional &&
            settings.authorizationStatus != AuthorizationStatus.authorized)) {
      Get.snackbar('Something Went Wrong',
          'Permissions are neccessary for notifications');
    }
  }

  Future<NotificationSettings?> _requestPermission() async {
    try {
      NotificationSettings notificationSettings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );

      return notificationSettings;
    } catch (e) {
      Get.snackbar('Something Went Wrong',
          'Permissions are neccessary for notifications');
      return null;
    }
  }

  // ignore: unused_element
  void _registerForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if (remoteMessage.notification != null) {
        String title = remoteMessage.notification?.title ?? '';
        String body = remoteMessage.notification?.body ?? '';
        LocalNotifications.showNotification(title: title, body: body);
        print(title);
        print(body);
      }
    });
  }
}
