import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _firestore = FirebaseFirestore.instance;
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    // Optional: Get FCM token
    final token = await _messaging.getToken();
    print('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    // Android Notification Channel
    const channel = AndroidNotificationChannel(
      'hedieaty_channel', // Unique ID for the channel
      'Hedieaty Notifications',
      description: 'Notifications for Hedieaty app.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS setup
    final initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize local notifications
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // TODO: Handle notification click
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'hedieaty_channel',
            'Hedieaty Notifications',
            channelDescription: 'Notifications for Hedieaty app.',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      // Store notification in Firestore
      await _firestore.collection('notifications').add({
        'title': notification.title,
        'body': notification.body,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false, // Mark as unread initially
      });
    }
  }






  Future<void> _setupMessageHandlers() async {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // Background message handler
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle click on notification
    });

    // When app is opened from notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      // Handle notification
    }
  }
}
