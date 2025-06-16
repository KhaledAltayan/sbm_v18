import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JoinMeetingPage extends StatefulWidget {
  const JoinMeetingPage({super.key});

  @override
  State<JoinMeetingPage> createState() => _JoinMeetingPageState();
}

class _JoinMeetingPageState extends State<JoinMeetingPage> {
  final TextEditingController _roomController = TextEditingController();
  final jitsiMeet = JitsiMeet();

  void _joinMeeting() {
    final roomId = _roomController.text.trim();
    if (roomId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Room ID')),
      );
      return;
    }

    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.ffmuc.net/",
      room: roomId,
      userInfo: JitsiMeetUserInfo(displayName: "Participant"),
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
       "startWithAudioMuted": false,
        "startWithVideoMuted": false,
        "disableDeepLinking": true,
        "disableThirdPartyRequests": true,
        "subject": "Smart Business Meeting",
      },
    );

    jitsiMeet.join(options);
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Join Meeting"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Room ID to Join",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _roomController,
              decoration: InputDecoration(
                hintText: 'e.g. room_123456',
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _joinMeeting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Join Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
