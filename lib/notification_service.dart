// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:sbm_v18/core/model/token_model.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.instance.setupFlutterNotifications();
//   await NotificationService.instance.showNotification(message);
// }

// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse details) {
//   NotificationService.instance._handleNotificationAction(
//     details.payload,
//     details.actionId,
//   );
// }

// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();
//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLocalNotificationsInitialized = false;

//   Future<void> initialize() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     await _requestPermission();
//     await _setupMessageHandlers();

//     final token = await _messaging.getToken();
//     if (token != null) {
//       TokenModel.fcm = token;
//     }

//     print("FCM Token: $token");
//   }

//   Future<void> _requestPermission() async {
//     final settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//       announcement: false,
//       carPlay: false,
//       criticalAlert: false,
//     );
//     print('Permission status: ${settings.authorizationStatus}');
//   }

//   Future<void> setupFlutterNotifications() async {
//     if (_isFlutterLocalNotificationsInitialized) {
//       return;
//     }
//     // android

//     const channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     const InitializationSettingsAndroid = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     final _InitializationSettings = InitializationSettings(
//       android: InitializationSettingsAndroid,
//     );

//     await _localNotifications.initialize(
//       _InitializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         _handleNotificationAction(details.payload, details.actionId);
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//     _isFlutterLocalNotificationsInitialized = true;
//   }

//   void _handleNotificationAction(String? payload, String? actionId) {
//     if (actionId == 'accept_action') {
//       if (kDebugMode) {
//         print('User tapped Accept**********************************');
//       }
//       // TODO: Add accept logic here
//     } else if (actionId == 'reject_action') {
//       if (kDebugMode) {
//         print('User tapped Reject*******************************');
//       }
//       // TODO: Add reject logic here
//     } else {
//       if (kDebugMode) {
//         print('Notification tapped without action');
//       }
//     }
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,

//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel', // Must match the created channel ID exactly
//             'High Importance Notifications',
//             channelDescription:
//                 'This channel is used for important notifications.',
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//             actions: <AndroidNotificationAction>[
//               AndroidNotificationAction(
//                 'accept_action',
//                 'Accept',

//                 showsUserInterface: true,
//                 cancelNotification: true,
//               ),
//               AndroidNotificationAction(
//                 'reject_action',
//                 'Reject',
//                 showsUserInterface: true,
//                 cancelNotification: true,
//               ),
//             ],
//           ),
//         ),

//         payload: message.data.toString(),
//       );
//     }
//   }

//   Future<void> _setupMessageHandlers() async {
//     // foreground
//     FirebaseMessaging.onMessage.listen((message) {
//       showNotification(message);
//     });

//     // background
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

//     // opened app
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleBackgroundMessage(initialMessage);
//     }
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//     if (message.data['type'] == 'chat') {
//       // open chat screen
//     }
//   }
// }

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sbm_v18/core/services/api_service.dart';

// Note: You'll need a way to access your TokenModel.
// This example assumes it's accessible.
// import 'package:sbm_v18/core/model/token_model.dart';
// Note: For navigation from a background isolate, a GlobalKey is a common pattern.
// import 'package:sbm_v18/main.dart'; // Assuming a navigatorKey is defined in main.dart

/// This top-level function is the entry point for notifications that arrive
/// when the app is in the background or terminated. It runs in a separate isolate.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // It's crucial to initialize services here because this isolate is separate
  // from your main application isolate.
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

/// This is the entry point for when a user taps a notification *action button*
/// while the app is in the background.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  if (kDebugMode) {
    print(
      "Notification action tapped in background: action '${details.actionId}' with payload: ${details.payload}",
    );
  }
  // This function acts as a bridge from the background isolate to our main service logic.
  NotificationService.instance.handleNotificationAction(
    details.payload,
    details.actionId,
  );
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  // final ApiService _apiService = ApiService();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // --- Public API ---

  /// Initializes all notification services. Call this once from your app's startup logic.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // It's best practice to request permissions early.
    await _requestPermission();

    // Set up local notifications (channels, handlers) before setting up FCM listeners.
    await setupFlutterNotifications();

    // Set up listeners for all FCM message scenarios.
    _setupFCMListeners();

    // Get the initial FCM token and listen for refreshes.
    await _getAndPrintFCMToken();

    _isInitialized = true;
  }

  /// Sets up the FlutterLocalNotificationsPlugin, including the Android channel
  /// and the handlers for when a notification is tapped.
  Future<void> setupFlutterNotifications() async {
    // Android-specific: Create a channel.
    // Notifications won't appear on Android 8.0+ without a channel.
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Initialization settings for Android and iOS (iOS is simpler).
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings,
      // Handles taps on notifications (body or actions) when the app is in the FOREGROUND.
      onDidReceiveNotificationResponse: (details) {
        if (kDebugMode) {
          print(
            "Notification tapped in foreground: action '${details.actionId}' with payload: ${details.payload}",
          );
        }
        handleNotificationAction(details.payload, details.actionId);
      },
      // Handles taps on notification ACTIONS when the app is in the BACKGROUND.
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /// Displays a local notification using the data from an FCM RemoteMessage.
  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      if (kDebugMode) {
        print("Cannot show notification, RemoteMessage.notification is null.");
      }
      return;
    }

    // CRITICAL: Use jsonEncode to create a reliable, parsable string from the data map.
    // .toString() is for debugging only and is not a valid data format.
    final payload = jsonEncode(message.data);

    await _localNotifications.show(
      notification.hashCode, // Use a unique ID for the notification
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // This ID MUST match the channel created above.
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          actions: <AndroidNotificationAction>[
            const AndroidNotificationAction(
              'accept_action', // The ID you will check for in your handler.
              'Accept',
              showsUserInterface: true,
              cancelNotification: true,
            ),
            const AndroidNotificationAction(
              'reject_action', // The ID you will check for in your handler.
              'Reject',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      payload: payload,
    );
  }

  /// This is the single, centralized handler for all notification actions.
  /// It reliably decodes the payload and executes logic based on the actionId.
  // void handleNotificationAction(String? payload, String? actionId) {
  //   if (kDebugMode) {
  //     print("Handling action: '$actionId' with payload: $payload");
  //   }

  //   // Safely decode the JSON payload.
  //   Map<String, dynamic> data = {};
  //   if (payload != null && payload.isNotEmpty) {
  //     try {
  //       data = jsonDecode(payload);
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print("Error decoding notification payload: $e");
  //       }
  //     }
  //   }

  //   // Use a switch for clear, readable logic.
  //   switch (actionId) {
  //     case 'accept_action':
  //       if (kDebugMode) {
  //         print('User tapped Accept. Data: $data');
  //       }
  //       // --- YOUR ACCEPT LOGIC HERE ---
  //       // e.g., make an API call: apiService.acceptInvitation(data['invitationId']);
  //       break;
  //     case 'reject_action':
  //       if (kDebugMode) {
  //         print('User tapped Reject. Data: $data');
  //       }
  //       // --- YOUR REJECT LOGIC HERE ---
  //       // e.g., make an API call: apiService.rejectInvitation(data['invitationId']);
  //       break;
  //     default:
  //       // This handles a tap on the notification body itself (where actionId is null).
  //       if (kDebugMode) {
  //         print('Notification tapped without a specific action. Navigating...');
  //       }
  //       _navigateToScreenFromPayload(data);
  //       break;
  //   }
  // }

  void handleNotificationAction(String? payload, String? actionId) {
    if (kDebugMode) {
      print("تم الضغط على الإشعار: '$actionId' مع البيانات: $payload");
    }

    Map<String, dynamic> data = {};
    if (payload != null && payload.isNotEmpty) {
      try {
        data = jsonDecode(payload);
      } catch (e) {
        print("خطأ في فك ترميز البيانات: $e");
      }
    }

    final invitationId = data['invitation_id'];

    switch (actionId) {
      case 'accept_action':
        if (invitationId != null) {
          // _apiService.acceptInvitation(invitationId.toString());
        }
        break;

      case 'reject_action':
        if (invitationId != null) {
          // _apiService.rejectInvitation(invitationId.toString());
        }
        break;

      default:
        _navigateToScreenFromPayload(data);
        break;
    }
  }

  // --- Private Helpers ---

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission();
    if (kDebugMode) {
      print('FCM Permission status: ${settings.authorizationStatus}');
    }
  }

  void _setupFCMListeners() {
    // 1. For messages that arrive when the app is in the FOREGROUND.
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print('FCM message received while app is in foreground.');
      }
      // Display a local notification so the user sees it.
      showNotification(message);
    });

    // 2. For handling a tap on a notification when the app is in the BACKGROUND.
    // Note: This is for taps on the main body, NOT action buttons.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('Notification opened from background.');
      }
      _navigateToScreenFromPayload(message.data);
    });

    // 3. For handling a tap on a notification that opened the app from a TERMINATED state.
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        if (kDebugMode) {
          print('Notification opened from terminated state.');
        }
        _navigateToScreenFromPayload(message.data);
      }
    });

    // 4. Register the top-level background message handler.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _getAndPrintFCMToken() async {
    final token = await _messaging.getToken();
    if (token != null) {


      // TokenModel.fcm = token; // Uncomment when your model is available
    }
    if (kDebugMode) {
      print("FCM Token: $token");

      
    }
    // Also listen for token refreshes and send them to your server.
    _messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        print("FCM Token refreshed: $newToken");
      }
      // TokenModel.fcm = newToken;
      // TODO: Send the new token to your backend server.
    });
  }

  /// A helper to contain your navigation logic.
  void _navigateToScreenFromPayload(Map<String, dynamic> data) {
    // This is where you would implement your navigation logic.
    // To navigate from outside the widget tree (e.g., from a service),
    // you typically use a GlobalKey<NavigatorState> on your MaterialApp.
    final type = data['type'];
    if (type == 'chat') {
      final chatId = data['chat_id'];
      if (kDebugMode) {
        print("Navigation requested to Chat screen with ID: $chatId");
      }
      // Example: navigatorKey.currentState?.pushNamed('/chat', arguments: chatId);
    }
  }
}
