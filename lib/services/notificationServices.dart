import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../globals.dart';
import '../screens/gpsTrackingScreen.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._();

  factory NotificationService() => _notificationService;

  NotificationService._();

  /// function to initialise notification plugin
  Future initialiseNotificationPlugin() async {
    try {
      AwesomeNotifications().initialize(
          'resource://drawable/app_icon',
          [
            notificationChannel
          ],
          debug: true
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  NotificationChannel notificationChannel = NotificationChannel(
    channelKey: channelKey,
    channelName: channelName,
    channelDescription: channelDescription,
    defaultColor: kSpringColor,
    ledColor: kPrimaryColor,
    playSound: false,
    enableLights: true,
    enableVibration: true,
    locked: false,
  );

  static String channelKey = '1';
  static String channelName = 'track';
  static String channelDescription = 'to display notification for the track in progress';

  Future showNotifications(String title, String body) async {
    const NotificationLayout notificationLayout = NotificationLayout.BigText;
    const NotificationLifeCycle notificationLifeCycle = NotificationLifeCycle.Foreground;

    final NotificationContent notificationContent = NotificationContent(
      id: 1,
      channelKey: channelKey,
      title: title,
      body: body,
      icon: 'resource://drawable/app_icon',
      autoCancel: false,
      // payload: payload,
      hideLargeIconOnExpand: true,
      notificationLayout: notificationLayout,
      locked: true,
      displayOnBackground: true,
      displayOnForeground: true,
      displayedDate: DateTime.now().toLocal().toString().substring(0, 19),
      displayedLifeCycle: notificationLifeCycle,
      // summary: '$title $body'
    );

    final NotificationActionButton notificationActionButton = NotificationActionButton(
      key: 'actionButton',
      enabled: true,
      buttonType: ActionButtonType.KeepOnTop,
      autoCancel: false,
      label: 'stop track'.toUpperCase(),
    );

    await AwesomeNotifications().createNotification(
      content: notificationContent,
      actionButtons: [notificationActionButton],
    );

    listenToNotification();
  }

  void listenToNotification() {
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      Navigator.pushReplacementNamed(navigatorKey.currentState.context, GpsTrackingScreen.routeName);
    });
  }

  Future turnOffNotification() async {
    AwesomeNotifications().cancelAll();
  }

  void requestNotificationPermissions() {
    AwesomeNotifications().isNotificationAllowed().then((bool allowed) {
      if (!allowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

}