import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qrpay/models/push_notification.dart';

import 'firebase_service.dart';
import 'ui_services.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  BackgroundMessageHandler get firebaseMessagingBackgroundHandler => null;

  void registerNotification(BuildContext context) async {
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification =
            PushNotification.fromRemoteMessage(message);

        if (notification != null) {
          // For displaying the notification as an overlay
          UIServices().showPopUpPushNotification(notification, context);
        } else {}
      });
    } else {}
  }

  checkForInitialMessage(BuildContext context) async {
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification =
          PushNotification.fromRemoteMessage(initialMessage);

      UIServices().showPopUpPushNotification(notification, context);
    } else {}
  }

  onMessageAppListen(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification =
          PushNotification.fromRemoteMessage(message);

      StorageServices().handlePushNotificationClick(notification, context);
    });
  }
}
