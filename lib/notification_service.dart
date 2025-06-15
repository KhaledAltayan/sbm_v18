import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sbm_v18/core/model/token_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  NotificationService.instance._handleNotificationAction(
    details.payload,
    details.actionId,
  );
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupMessageHandlers();

    final token = await _messaging.getToken();
    if (token != null) {
      TokenModel.fcm = token;
    }

    print("FCM Token: $token");
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }
    // android

    const channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const InitializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final _InitializationSettings = InitializationSettings(
      android: InitializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      _InitializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleNotificationAction(details.payload, details.actionId);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    _isFlutterLocalNotificationsInitialized = true;
  }

  void _handleNotificationAction(String? payload, String? actionId) {
    if (actionId == 'accept_action') {
      if (kDebugMode) {
        print('User tapped Accept**********************************');
      }
      // TODO: Add accept logic here
    } else if (actionId == 'reject_action') {
      if (kDebugMode) {
        print('User tapped Reject*******************************');
      }
      // TODO: Add reject logic here
    } else {
      if (kDebugMode) {
        print('Notification tapped without action');
      }
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,

        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Must match the created channel ID exactly
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'accept_action',
                'Accept',
                showsUserInterface: true,
                cancelNotification: true,
              ),
              AndroidNotificationAction(
                'reject_action',
                'Reject',
                showsUserInterface: true,
                cancelNotification: true,
              ),
            ],
          ),
        ),

        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // foreground
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // open chat screen
    }
  }
}
