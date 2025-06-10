import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class MeetingPage4 extends StatefulWidget {
  const MeetingPage4({super.key});

  @override
  State<MeetingPage4> createState() => _MeetingPage4State();
}

class _MeetingPage4State extends State<MeetingPage4> {
  final TextEditingController roomController = TextEditingController();

  final JitsiMeet jitsiMeet = JitsiMeet();

  void joinAsAdmin(String room) {
    final options = JitsiMeetConferenceOptions(
      // serverURL: "https://meet.jit.si",
      serverURL: "https://meet.ffmuc.net/",
      room: room,
      userInfo: JitsiMeetUserInfo(displayName: "Admin"),
      featureFlags: {
        FeatureFlags.meetingNameEnabled: true,
        FeatureFlags.kickOutEnabled: true,
        //************************************ */
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
        FeatureFlags.recordingEnabled:true
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
      // serverURL: "https://meet.jit.si",
      serverURL: "https://meet.ffmuc.net/",
      room: room,
      userInfo: JitsiMeetUserInfo(displayName: "Participant"),
      featureFlags: {
        FeatureFlags.lobbyModeEnabled: false, // تفعيل وضع اللوبّي
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
    // مثال بسيط لتوليد اسم غرفة عشوائي
    return "room_${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jitsi Lobby Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: roomController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Room Name (مثلاً: my_meet123)",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final room = generateRoomName();
                print(room);
                roomController.text = room;
                joinAsAdmin(room);
              },
              child: const Text("New Meeting (Create & Join as Admin)"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final room = roomController.text.trim();
                if (room.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter room name")),
                  );
                  return;
                }
                joinAsParticipant(room);
              },
              child: const Text("Join Meeting (Wait in Lobby)"),
            ),
          ],
        ),
      ),
    );
  }
}
