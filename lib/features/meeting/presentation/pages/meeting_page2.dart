import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';

class MeetingPage2 extends StatefulWidget {
  const MeetingPage2({super.key});

  @override
  State<MeetingPage2> createState() => _MeetingPage2State();
}

class _MeetingPage2State extends State<MeetingPage2> {
  final TextEditingController meetingNameController = TextEditingController();
  final jitsiMeet = JitsiMeet();

  void joinMeeting(String roomId, String name) {
    final options = JitsiMeetConferenceOptions(
      // serverURL: "https://meet.jit.si",
      serverURL: "https://meet.ffmuc.net/",
      room: roomId,

      // configOverrides: {
      //   "startWithAudioMuted": true,
      //   "startWithVideoMuted": true,
      //   "subject": "Meeting",
      // },
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
        "disableDeepLinking": true,
        "disableThirdPartyRequests": true,
        "audioQuality": {"opusMaxAverageBitrate": 32000},
        "subject": "Smart Business Meeting",
      },

      // featureFlags: {
      //   "unsaferoomwarning.enabled": false,
      //   "security-options.enabled": false,
      // },
      featureFlags: {
        FeatureFlags.addPeopleEnabled: true,
        FeatureFlags.welcomePageEnabled: true,
        FeatureFlags.preJoinPageEnabled: true,
        FeatureFlags.unsafeRoomWarningEnabled: true,
        FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
        FeatureFlags.audioFocusDisabled: true,
        FeatureFlags.audioMuteButtonEnabled: true,
        FeatureFlags.audioOnlyButtonEnabled: true,
        FeatureFlags.calenderEnabled: true,
        FeatureFlags.callIntegrationEnabled: true,
        FeatureFlags.carModeEnabled: true,
        FeatureFlags.closeCaptionsEnabled: true,
        FeatureFlags.conferenceTimerEnabled: true,
        FeatureFlags.chatEnabled: true,
        FeatureFlags.filmstripEnabled: true,
        FeatureFlags.fullScreenEnabled: true,
        FeatureFlags.helpButtonEnabled: true,
        FeatureFlags.inviteEnabled: true,
        FeatureFlags.androidScreenSharingEnabled: true,
        FeatureFlags.speakerStatsEnabled: true,
        FeatureFlags.kickOutEnabled: true,
        FeatureFlags.liveStreamingEnabled: true,
        FeatureFlags.lobbyModeEnabled: true,
        FeatureFlags.meetingNameEnabled: true,
        FeatureFlags.meetingPasswordEnabled: true,
        FeatureFlags.notificationEnabled: true,
        FeatureFlags.overflowMenuEnabled: true,
        FeatureFlags.pipEnabled: true,
        FeatureFlags.pipWhileScreenSharingEnabled: true,
        FeatureFlags.preJoinPageHideDisplayName: true,
        FeatureFlags.raiseHandEnabled: true,
        FeatureFlags.reactionsEnabled: true,
        FeatureFlags.recordingEnabled: true,
        FeatureFlags.replaceParticipant: true,
        FeatureFlags.securityOptionEnabled: true,
        FeatureFlags.serverUrlChangeEnabled: true,
        FeatureFlags.settingsEnabled: true,
        FeatureFlags.tileViewEnabled: true,
        FeatureFlags.videoMuteEnabled: true,
        FeatureFlags.videoShareEnabled: true,
        FeatureFlags.toolboxEnabled: true,
        FeatureFlags.iosRecordingEnabled: true,
        FeatureFlags.iosScreenSharingEnabled: true,
        FeatureFlags.toolboxAlwaysVisible: true,
      },
      userInfo: JitsiMeetUserInfo(
        displayName: name,
        email: "user@example.com", // يمكن تعديله
      ),
    );
    jitsiMeet.join(options);
  }

  //   void createAndJoinMeeting() async {

  //    context.read<MeetingCubit>().createMeeting(
  //     title: "Generated Meeting",
  //     startTime: DateTime.now().add(const Duration(minutes: 1)),
  //     duration: 2,
  //   );

  //   final state = cubit.state;
  //   if (state.meetings.isNotEmpty) {
  //     final meeting = state.meetings.last;
  //     final roomId = meeting.roomId;
  //     joinMeeting(roomId, "Auto User");
  //   } else {
  //     // Error handling
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to create meeting")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Meeting")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextField لإدخال اسم الغرفة
              TextField(
                controller: meetingNameController,
                decoration: const InputDecoration(
                  hintText: "Enter room name (e.g., jitsi_xyz123)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // زر الانضمام لاجتماع
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () {
                    final roomId = meetingNameController.text.trim();
                    if (roomId.isNotEmpty) {
                      joinMeeting(roomId, "Manual User");
                    }
                  },
                  icon: const Icon(Icons.video_call),
                  label: const Text("Join Meeting"),
                ),
              ),
              const SizedBox(height: 16),
              // زر إنشاء اجتماع جديد
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  //  createAndJoinMeeting,
                  icon: const Icon(Icons.add),
                  label: const Text("New Meeting"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
