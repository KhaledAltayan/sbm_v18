import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

class MeetingPage6 extends StatefulWidget {
  const MeetingPage6({super.key});

  @override
  State<MeetingPage6> createState() => _MeetingPage6State();
}

class _MeetingPage6State extends State<MeetingPage6> {
  final TextEditingController roomController = TextEditingController();
  final JitsiMeet jitsiMeet = JitsiMeet();
  final AudioRecorder recorder = AudioRecorder();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final PusherChannelsFlutter pusher = PusherChannelsFlutter();

  String? recordingPath;

  @override
  void initState() {
    super.initState();
    initNotifications();
    initPusher(123); // Replace with actual meeting ID
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationResponse,
    );
  }

  void onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    final data = payload?.split('|');
    final invitationId = data?[0];
    final roomId = data?[1];

    if (response.actionId == 'ACCEPT') {
      acceptUser(invitationId!);
    } else if (response.actionId == 'REJECT') {
      rejectUser(invitationId!);
    }
  }

  Future<void> showJoinRequestNotification(
      String name, String invitationId, String roomId) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meeting_channel',
      'Meeting Notifications',
      channelDescription: 'Notifications for meeting join requests',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('ACCEPT', 'قبول'),
        AndroidNotificationAction('REJECT', 'رفض'),
      ],
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      '🔔 طلب انضمام',
      '$name يطلب الانضمام إلى الاجتماع',
      platformDetails,
      payload: '$invitationId|$roomId',
    );
  }

  Future<void> initPusher(int meetingId) async {
    await pusher.init(
      apiKey: '380d95303fac6cdc3cb0',
      cluster: 'us2',
      onEvent: (event) {
        final data = jsonDecode(event.data ?? '{}');
        final name = data['name'];
        final invitationId = data['invitation_id'].toString();
        final roomId = data['room_id'].toString();
        showJoinRequestNotification(name, invitationId, roomId);
      },
      onSubscriptionSucceeded: onSubscriptionSucceeded,
    );

    await pusher.subscribe(channelName: 'private-meeting.$meetingId');
    await pusher.connect();
  }

void onSubscriptionSucceeded(String channelName, dynamic data) {
  log("✅ Subscribed to $channelName");
  log("📦 Subscription data: $data");
}



  Future<void> requestPermissions() async {
    await [
      Permission.microphone,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
  }

  Future<void> pickSaveLocation() async {
    await requestPermissions();

    Directory downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadsDir = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }

    final path =
        "${downloadsDir.path}/meeting_${DateTime.now().millisecondsSinceEpoch}.m4a";

    setState(() {
      recordingPath = path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📁 سيتم الحفظ في: $recordingPath")),
    );
  }

  Future<void> startRecording(String room) async {
    await requestPermissions();

    if (await recorder.hasPermission()) {
      if (recordingPath == null) {
        Directory downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory('/storage/emulated/0/Download');
        } else {
          downloadsDir = await getDownloadsDirectory() ??
              await getApplicationDocumentsDirectory();
        }
        recordingPath = "${downloadsDir.path}/$room.m4a";
      }

      await recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: recordingPath!,
      );
    }
  }

  Future<void> stopRecording() async {
    if (await recorder.isRecording()) {
      final path = await recorder.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✔️ تم حفظ التسجيل في: $path")),
      );
    }
  }

  Future<void> acceptUser(String invitationId) async {
    await http.post(Uri.parse("https://your-api.com/api/invitations/$invitationId/accept"));
  }

  Future<void> rejectUser(String invitationId) async {
    await http.post(Uri.parse("https://your-api.com/api/invitations/$invitationId/reject"));
  }

  void joinAsAdmin(String room) async {
    await startRecording(room);
    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.ffmuc.net/",
      room: room,
      userInfo: JitsiMeetUserInfo(displayName: "Admin"),
    );
    jitsiMeet.join(options);
  }

  void joinAsParticipant(String room) {
    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.ffmuc.net/",
      room: room,
      userInfo: JitsiMeetUserInfo(displayName: "Participant"),
    );
    jitsiMeet.join(options);
  }

  String generateRoomName() {
    return "room_${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meeting with Pusher & CallKit")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: roomController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Room Name",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickSaveLocation,
              child: const Text("📁 اختر مكان الحفظ"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final room = generateRoomName();
                roomController.text = room;
                joinAsAdmin(room);
              },
              child: const Text("🎥 إنشاء اجتماع (Admin)"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final room = roomController.text.trim();
                if (room.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("يرجى كتابة اسم الغرفة")),
                  );
                  return;
                }
                joinAsParticipant(room);
              },
              child: const Text("👥 انضمام للاجتماع"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: stopRecording,
              child: const Text("🛑 إيقاف التسجيل"),
            ),
          ],
        ),
      ),
    );
  }
}
