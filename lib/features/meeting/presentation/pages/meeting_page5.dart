import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';


class MeetingPage5 extends StatefulWidget {
  const MeetingPage5({super.key});

  @override
  State<MeetingPage5> createState() => _MeetingPage5State();
}

class _MeetingPage5State extends State<MeetingPage5> {
  final TextEditingController roomController = TextEditingController();
  final JitsiMeet jitsiMeet = JitsiMeet();
  final AudioRecorder recorder = AudioRecorder();

  String? recordingPath;

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

Future<void> pickSaveLocation() async {
  final dir = await getApplicationDocumentsDirectory(); // يمكنك تغييره إلى getDownloadsDirectory() لو أردت
  final path = "${dir.path}/meeting_${DateTime.now().millisecondsSinceEpoch}.m4a";

  setState(() {
    recordingPath = path;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("📁 سيتم الحفظ في: $recordingPath")),
  );
}

  Future<void> startRecording(String room) async {
    if (await recorder.hasPermission()) {
      if (recordingPath == null) {
        final dir = await getApplicationDocumentsDirectory();
        recordingPath = "${dir.path}/$room.m4a";
      }

      await recorder.start(
        RecordConfig(encoder: AudioEncoder.aacLc),
        path: recordingPath!,
      );

      print("🎙️ بدأ التسجيل: $recordingPath");
    }
  }

  Future<void> stopRecording() async {
    if (await recorder.isRecording()) {
      final path = await recorder.stop();
      print("🛑 تم إيقاف التسجيل: $path");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✔️ تم حفظ التسجيل في: $path")),
      );
    }
  }

  Future<void> joinAsAdmin(String room) async {
    await startRecording(room);

    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.ffmuc.net/",
      room: room,
      userInfo: JitsiMeetUserInfo(displayName: "Admin"),
      featureFlags: {
        FeatureFlags.meetingNameEnabled: true,
        FeatureFlags.kickOutEnabled: true,
        FeatureFlags.videoShareEnabled: false,
        FeatureFlags.securityOptionEnabled: false,
        FeatureFlags.meetingPasswordEnabled: false,
        FeatureFlags.preJoinPageEnabled: false,
        FeatureFlags.replaceParticipant: false,
        FeatureFlags.lobbyModeEnabled: false,
        FeatureFlags.unsafeRoomWarningEnabled: false,
        FeatureFlags.raiseHandEnabled: true,
        FeatureFlags.inviteEnabled: false,
        FeatureFlags.carModeEnabled: false,
        FeatureFlags.addPeopleEnabled: false,
        FeatureFlags.speakerStatsEnabled: true,
        FeatureFlags.recordingEnabled: true,
      },
      configOverrides: {
        "startWithAudioMuted": true,
        "startWithVideoMuted": true,
        "disableDeepLinking": true,
        "disableThirdPartyRequests": true,
        "subject": "Smart Business Meeting",
      },
    );

    jitsiMeet.join(options);
  }

  void joinAsParticipant(String room) {
    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.ffmuc.net/",
      room: room,
      userInfo: JitsiMeetUserInfo(displayName: "Participant"),
      featureFlags: {
        FeatureFlags.lobbyModeEnabled: false,
        FeatureFlags.inviteEnabled: false,
        FeatureFlags.meetingNameEnabled: true,
        FeatureFlags.kickOutEnabled: true,
      },
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
        "disableDeepLinking": true,
        "disableThirdPartyRequests": true,
        "subject": "Smart Business Meeting",
      },
    );

    jitsiMeet.join(options);
  }

  String generateRoomName() {
    return "room_${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jitsi Audio Recording")),
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
              child: const Text("🎥 اجتماع جديد (Admin)"),
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
              child: const Text("🛑 إيقاف التسجيل وحفظه"),
            ),
          ],
        ),
      ),
    );
  }
}
