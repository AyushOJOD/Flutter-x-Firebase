import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotficationService {
  static Future<void> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("Notification Initialized");
    }
  }
}
