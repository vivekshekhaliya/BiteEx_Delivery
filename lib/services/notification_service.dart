import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bite_ex_delivery/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<Map<String, dynamic>> onNotificationTap =
  StreamController.broadcast();

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  Future<void> initialize() async {
    // Request notification permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // Get FCM token
    String? token = await getToken();
    debugPrint('FCM Token: $token');

    // 🔥 INIT LOCAL NOTIFICATIONS WITH TAP HANDLER
    await flutterLocalNotificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = Map<String, dynamic>.from(jsonDecode(response.payload!));
          onNotificationTap.add(data);
        }
      },
    );

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.toMap()}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: android != null
                ? const AndroidNotificationDetails(
              'foreground_channel_id',
              'Foreground Notifications',
              importance: Importance.high,
              priority: Priority.high,
            )
                : null,
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    // Listen for notification interaction
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationTap.add(message.data);
    });
  }

  void setBadgeCount(int count) {
    if (Platform.isIOS) {
      FlutterNewBadger.setBadge(count);
    }
  }

  void dispose() {
    onNotificationTap.close();
  }
}
