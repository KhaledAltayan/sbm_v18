import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class JoinMeetingPage extends StatefulWidget {
  const JoinMeetingPage({super.key});

  @override
  State<JoinMeetingPage> createState() => _JoinMeetingPageState();
}

class _JoinMeetingPageState extends State<JoinMeetingPage> {
  final TextEditingController _codeController = TextEditingController();
  late PusherChannelsFlutter pusher;
  bool isWaitingApproval = false;
  String connectionStatus = 'Disconnected';

  @override
  void initState() {
    super.initState();
    _initPusher();
  }

  void _initPusher() async {
    pusher = PusherChannelsFlutter();

    try {
      await pusher.init(
        apiKey: '380d95303fac6cdc3cb0',
        cluster: 'us2',
        onConnectionStateChange: (currentState, previousState) {
          setState(() => connectionStatus = currentState.toString());
        },
        onEvent: (event) {
          if (event.eventName == 'meeting-approved') {
            final room = event.data['room']; // You might need to parse JSON
            _joinJitsi(room);
          }
        },
      );

      await pusher.subscribe(channelName: 'meeting');
      await pusher.connect();
    } catch (e) {
      setState(() => connectionStatus = 'Error: $e');
    }
  }

  void _requestToJoin() {
    final roomCode = _codeController.text.trim();
    if (roomCode.isEmpty) return;

    // Notify the server/admin via API or Pusher to request approval
    // For this example, we assume server triggers an event "meeting-approved"

    setState(() => isWaitingApproval = true);
    // Simulated: In production, emit event to server with roomCode
  }

  void _joinJitsi(String room) {
    final jitsiMeet = JitsiMeet();
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

  @override
  void dispose() {
    pusher.unsubscribe(channelName: 'meeting');
    pusher.disconnect();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Meeting")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Enter Meeting Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestToJoin,
              child: const Text("Request to Join"),
            ),
            const SizedBox(height: 20),
            if (isWaitingApproval)
              const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 10),
            Text("Connection: $connectionStatus"),
          ],
        ),
      ),
    );
  }
}
