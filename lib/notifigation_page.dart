// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     _initNotification();
//   }

//   Future<void> _initNotification() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);

//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//   }

//   Future<void> _showNotification() async {
//     const androidDetails = AndroidNotificationDetails(
//       'test_channel',
//       'Test Channel',
//       channelDescription: 'For simple local tests',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const notificationDetails = NotificationDetails(android: androidDetails);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       '🔔 Local Notification',
//       'This is a test from NotificationPage!',
//       notificationDetails,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Notification Page')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _showNotification,
//           child: const Text('Show Local Notification'),
//         ),
//       ),
//     );
//   }
// }
