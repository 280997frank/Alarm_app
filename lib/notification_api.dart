import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:alarm_app/alarm.dart';

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


  static Future<void> showNotification(Alarm alarm) async {
    print('ini alarm ' + alarm.active.toString());
    if (alarm.active) {
      var iosDetails = new IOSNotificationDetails();
      var generalNotification = new NotificationDetails(iOS: iosDetails);
      await localNotification.schedule(
          alarm.id, 'Alarm', 'Segera Matikan Alarm', alarm.clock, generalNotification);
    }
  }
}


