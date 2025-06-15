// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationPage2 extends StatefulWidget {
//   const NotificationPage2({super.key});

//   @override
//   State<NotificationPage2> createState() => _NotificationPage2State();
// }

// class _NotificationPage2State extends State<NotificationPage2> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   String _actionMessage = 'No action taken yet.';

//   @override
//   void initState() {
//     super.initState();
//     _initNotification();
//   }

//   Future<void> _initNotification() async {
//     const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidInitSettings);

//     await flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         if (response.actionId == 'accept') {
//           setState(() => _actionMessage = '✅ Call Accepted');
//         } else if (response.actionId == 'reject') {
//           setState(() => _actionMessage = '❌ Call Rejected');
//         }
//       },
//     );
//   }

//   Future<void> _showNotification() async {
//     const androidDetails = AndroidNotificationDetails(
//       'test_channel',
//       'Test Channel',
//       channelDescription: 'For simple local tests',
//       importance: Importance.max,
//       priority: Priority.high,
//       actions: <AndroidNotificationAction>[
//         AndroidNotificationAction(
//           'accept',
//           'Accept',
//           icon: DrawableResourceAndroidBitmap('ic_launcher'),
//         ),
//         AndroidNotificationAction(
//           'reject',
//           'Reject',
//           icon: DrawableResourceAndroidBitmap('ic_launcher'),
//         ),
//       ],
//     );

//     const notificationDetails = NotificationDetails(android: androidDetails);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Incoming Call',
//       'Would you like to accept?',
//       notificationDetails,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Notification Page')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _showNotification,
//               child: const Text('Show Notification with Actions'),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _actionMessage,
//               style: const TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
