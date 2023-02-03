import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._();

  factory NotificationService() => _notificationService;

  NotificationService._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// function to initialise location plugin
  Future initialiseNotificationPlugin() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {}

  Future onSelectNotification(String? payload) async {
    // handle notification tapped logic
    if (payload != null) {
      debugPrint('notification $payload');
    }
  }

  static String channelId = '1';
  static String channelName = 'track';
  static String channelDescription =
      'to display notification for the track in progress';

  // android platform channel specifics
  static AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    channelId, //Required for Android 8.0 or after,
    channelName, //Required for Android 8.0 or after
    importance: Importance.high,
    priority: Priority.high,
    autoCancel: false,
  );

  static List<IOSNotificationAttachment> iosNotificationAttachment = [
    const IOSNotificationAttachment('assets/icons/appIcon.png')
  ];

  // iOS platform channel specifics
  static IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
    presentAlert:
        false, // presents an alert when the notification is displayed and the app is in foreground (from iOS 10 onwards)
    presentBadge:
        false, // presents the badge number when the notification is displayed and the app is in foreground (from iOS 10 onwards)
    presentSound:
        false, // play a sound when the notification is displayed and the app is in foreground (from iOS 10 onwards)
    attachments: iosNotificationAttachment, // only from iOS 10 onwards
    subtitle:
        channelDescription, // secondary description (only from iOS 10 onwards)
    threadIdentifier: channelId, // only from iOS 10 onwards
  );

  // platform channel specifics
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );

  void showNotifications(String title, String body, String routeName) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: routeName,
    );
  }

  Future turnOffNotification() async {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
