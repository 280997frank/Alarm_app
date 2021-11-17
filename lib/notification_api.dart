import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static FlutterLocalNotificationsPlugin localNotification;

  static Future<void> initialize() async {
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(iOS: iOSInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  static NotificationDetails notificationDetails() {
    print('masuk sini');
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }


  static Future<bool> showNotification(DateTime clock, bool alarm) async {
    bool isDifference = clock.difference(DateTime.now()).inMilliseconds <= -1;
    if (isDifference) {
      return false;
    }

    if (alarm) {
      var iosDetails = new IOSNotificationDetails();
      var generalNotification = new NotificationDetails(iOS: iosDetails);
      await localNotification.schedule(0, 'Alarm', 'Segera Matikan Alarm', clock, generalNotification);

      return true;
    }

    return false;
  }
}


