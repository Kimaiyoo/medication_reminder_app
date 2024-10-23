import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    tz.initializeTimeZones(); // Initialize timezones
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Update with your app icon

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledTime) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    // Update the AndroidNotificationDetails constructor
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medicine_reminder_channel', // Channel ID
      'Medicine Reminders', // Channel name
      channelDescription:
          'Channel for Medicine Reminder Notifications', // Named parameter for description
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
          'notification_sound'), // Update with your sound file
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title,
      body,
      scheduledDate, // Use the TZDateTime object
      platformChannelSpecifics,
      androidScheduleMode:
          AndroidScheduleMode.exact, // Use the new parameter instead
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      log('Notification payload: $payload');
      // You can navigate to a specific screen based on payload
    }
  }
}
