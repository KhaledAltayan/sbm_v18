// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

// class JitsiService {
//   final JitsiMeet jitsiMeet = JitsiMeet();
//   late JitsiMeetConferenceOptions options;
//   late JitsiMeetEventListener listener;
//   late String roomId;

//   JitsiService({
//     required String room,
//     required String displayName,
//     required String avatar,
//     required String email,
//   }) {
//     listener = JitsiMeetEventListener(
//       participantJoined: (email, name, role, participantId) {},

//       readyToClose: () {
//         closeChat();
//       },
//     );

//     options = JitsiMeetConferenceOptions(
//       serverURL: "https://meet.ffmuc.net/",
//       room: room,
//       configOverrides: {
//         "startWithAudioMuted": false,
//         "startWithVideoMuted": false,
//         "disableDeepLinking": true,
//         "disableThirdPartyRequests": true,
//         "audioQuality": {"opusMaxAverageBitrate": 32000},
//         "subject": "Smart Business Meeting",
//       },

//       featureFlags: {

//         FeatureFlags.addPeopleEnabled: true,
//         FeatureFlags.welcomePageEnabled: true,
//         FeatureFlags.preJoinPageEnabled: true,
//         FeatureFlags.unsafeRoomWarningEnabled: true,
//         FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
//         FeatureFlags.audioFocusDisabled: true,
//         FeatureFlags.audioMuteButtonEnabled: true,
//         FeatureFlags.audioOnlyButtonEnabled: true,
//         FeatureFlags.calenderEnabled: true,
//         FeatureFlags.callIntegrationEnabled: true,
//         FeatureFlags.carModeEnabled: true,
//         FeatureFlags.closeCaptionsEnabled: true,
//         FeatureFlags.conferenceTimerEnabled: true,
//         FeatureFlags.chatEnabled: true,
//         FeatureFlags.filmstripEnabled: true,
//         FeatureFlags.fullScreenEnabled: true,
//         FeatureFlags.helpButtonEnabled: true,
//         FeatureFlags.inviteEnabled: true,
//         FeatureFlags.androidScreenSharingEnabled: true,
//         FeatureFlags.speakerStatsEnabled: true,
//         FeatureFlags.kickOutEnabled: true,
//         FeatureFlags.liveStreamingEnabled: true,
//         FeatureFlags.lobbyModeEnabled: true,
//         FeatureFlags.meetingNameEnabled: true,
//         FeatureFlags.meetingPasswordEnabled: true,
//         FeatureFlags.notificationEnabled: true,
//         FeatureFlags.overflowMenuEnabled: true,
//         FeatureFlags.pipEnabled: true,
//         FeatureFlags.pipWhileScreenSharingEnabled: true,
//         FeatureFlags.preJoinPageHideDisplayName: true,
//         FeatureFlags.raiseHandEnabled: true,
//         FeatureFlags.reactionsEnabled: true,
//         FeatureFlags.recordingEnabled: true,
//         FeatureFlags.replaceParticipant: true,
//         FeatureFlags.securityOptionEnabled: true,
//         FeatureFlags.serverUrlChangeEnabled: true,
//         FeatureFlags.settingsEnabled: true,
//         FeatureFlags.tileViewEnabled: true,
//         FeatureFlags.videoMuteEnabled: true,
//         FeatureFlags.videoShareEnabled: true,
//         FeatureFlags.toolboxEnabled: true,
//         FeatureFlags.iosRecordingEnabled: true,
//         FeatureFlags.iosScreenSharingEnabled: true,
//         FeatureFlags.toolboxAlwaysVisible: true,
//       },
//     );
//   }

//   Future<void> startMeeting(BuildContext context) async {
//     try {
//       await jitsiMeet.join(options, listener);
//       if (kDebugMode) {
//         print('Voice call options: starting ${options.serverURL}');
//       }
//     } catch (error) {
//       debugPrint("Error Starting Jitsi Meeting : $error");
//     }
//   }

//   /// *********************************************************************************
//   var options2 = JitsiMeetConferenceOptions(
//     serverURL: "https://meet.jit.si",
//     room: "jitsiIsAwesomeWithFlutter",
//     configOverrides: {
//       "startWithAudioMuted": false,
//       "startWithVideoMuted": false,
//       "subject": "Jitsi with Flutter",
//     },
//     featureFlags: {"unsaferoomwarning.enabled": false},
//     userInfo: JitsiMeetUserInfo(
//       displayName: "Flutter user",
//       email: "user@example.com",
//     ),
//   );

//   bool audioMuted = true;
//   bool videoMuted = true;
//   bool screenShareOn = false;
//   List<String> participants = [];
//   final _jitsiMeetPlugin = JitsiMeet();

//   join() async {
//     var options = JitsiMeetConferenceOptions(
//       room: "testgabigabi",
//       configOverrides: {
//         "startWithAudioMuted": true,
//         "startWithVideoMuted": true,
//       },
//       featureFlags: {
//         FeatureFlags.addPeopleEnabled: true,
//         FeatureFlags.welcomePageEnabled: true,
//         FeatureFlags.preJoinPageEnabled: true,
//         FeatureFlags.unsafeRoomWarningEnabled: true,
//         FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
//         FeatureFlags.audioFocusDisabled: true,
//         FeatureFlags.audioMuteButtonEnabled: true,
//         FeatureFlags.audioOnlyButtonEnabled: true,
//         FeatureFlags.calenderEnabled: true,
//         FeatureFlags.callIntegrationEnabled: true,
//         FeatureFlags.carModeEnabled: true,
//         FeatureFlags.closeCaptionsEnabled: true,
//         FeatureFlags.conferenceTimerEnabled: true,
//         FeatureFlags.chatEnabled: true,
//         FeatureFlags.filmstripEnabled: true,
//         FeatureFlags.fullScreenEnabled: true,
//         FeatureFlags.helpButtonEnabled: true,
//         FeatureFlags.inviteEnabled: true,
//         FeatureFlags.androidScreenSharingEnabled: true,
//         FeatureFlags.speakerStatsEnabled: true,
//         FeatureFlags.kickOutEnabled: true,
//         FeatureFlags.liveStreamingEnabled: true,
//         FeatureFlags.lobbyModeEnabled: true,
//         FeatureFlags.meetingNameEnabled: true,
//         FeatureFlags.meetingPasswordEnabled: true,
//         FeatureFlags.notificationEnabled: true,
//         FeatureFlags.overflowMenuEnabled: true,
//         FeatureFlags.pipEnabled: true,
//         FeatureFlags.pipWhileScreenSharingEnabled: true,
//         FeatureFlags.preJoinPageHideDisplayName: true,
//         FeatureFlags.raiseHandEnabled: true,
//         FeatureFlags.reactionsEnabled: true,
//         FeatureFlags.recordingEnabled: true,
//         FeatureFlags.replaceParticipant: true,
//         FeatureFlags.securityOptionEnabled: true,
//         FeatureFlags.serverUrlChangeEnabled: true,
//         FeatureFlags.settingsEnabled: true,
//         FeatureFlags.tileViewEnabled: true,
//         FeatureFlags.videoMuteEnabled: true,
//         FeatureFlags.videoShareEnabled: true,
//         FeatureFlags.toolboxEnabled: true,
//         FeatureFlags.iosRecordingEnabled: true,
//         FeatureFlags.iosScreenSharingEnabled: true,
//         FeatureFlags.toolboxAlwaysVisible: true,
//       },
//       userInfo: JitsiMeetUserInfo(
//         displayName: "Gabi",
//         email: "gabi.borlea.1@gmail.com",
//         avatar:
//             "https://avatars.githubusercontent.com/u/57035818?s=400&u=02572f10fe61bca6fc20426548f3920d53f79693&v=4",
//       ),
//     );

//     var listener = JitsiMeetEventListener(
//       conferenceJoined: (url) {
//         debugPrint("conferenceJoined: url: $url");
//       },
//       conferenceTerminated: (url, error) {
//         debugPrint("conferenceTerminated: url: $url, error: $error");
//       },
//       conferenceWillJoin: (url) {
//         debugPrint("conferenceWillJoin: url: $url");
//       },
//       participantJoined: (email, name, role, participantId) {
//         debugPrint(
//           "participantJoined: email: $email, name: $name, role: $role, "
//           "participantId: $participantId",
//         );
//         participants.add(participantId!);
//       },
//       participantLeft: (participantId) {
//         debugPrint("participantLeft: participantId: $participantId");
//       },
//       audioMutedChanged: (muted) {
//         debugPrint("audioMutedChanged: isMuted: $muted");
//       },
//       videoMutedChanged: (muted) {
//         debugPrint("videoMutedChanged: isMuted: $muted");
//       },
//       endpointTextMessageReceived: (senderId, message) {
//         debugPrint(
//           "endpointTextMessageReceived: senderId: $senderId, message: $message",
//         );
//       },
//       screenShareToggled: (participantId, sharing) {
//         debugPrint(
//           "screenShareToggled: participantId: $participantId, "
//           "isSharing: $sharing",
//         );
//       },
//       chatMessageReceived: (senderId, message, isPrivate, timestamp) {
//         debugPrint(
//           "chatMessageReceived: senderId: $senderId, message: $message, "
//           "isPrivate: $isPrivate, timestamp: $timestamp",
//         );
//       },
//       chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
//       participantsInfoRetrieved: (participantsInfo) {
//         debugPrint(
//           "participantsInfoRetrieved: participantsInfo: $participantsInfo, ",
//         );
//       },
//       readyToClose: () {
//         debugPrint("readyToClose");
//       },
//     );
//     await _jitsiMeetPlugin.join(options, listener);
//   }

//   hangUp() async {
//     await _jitsiMeetPlugin.hangUp();
//   }

//   setAudioMuted(bool? muted) async {
//     var a = await _jitsiMeetPlugin.setAudioMuted(muted!);
//     debugPrint("$a");
//     setState(() {
//       audioMuted = muted;
//     });
//   }

//   setVideoMuted(bool? muted) async {
//     var a = await _jitsiMeetPlugin.setVideoMuted(muted!);
//     debugPrint("$a");
//     setState(() {
//       videoMuted = muted;
//     });
//   }

//   sendEndpointTextMessage() async {
//     var a = await _jitsiMeetPlugin.sendEndpointTextMessage(message: "HEY");
//     debugPrint("$a");

//     for (var p in participants) {
//       var b = await _jitsiMeetPlugin.sendEndpointTextMessage(
//         to: p,
//         message: "HEY",
//       );
//       debugPrint("$b");
//     }
//   }

//   toggleScreenShare(bool? enabled) async {
//     await _jitsiMeetPlugin.toggleScreenShare(enabled!);

//     setState(() {
//       screenShareOn = enabled;
//     });
//   }

//   openChat() async {
//     await _jitsiMeetPlugin.openChat();
//   }

//   sendChatMessage() async {
//     var a = await _jitsiMeetPlugin.sendChatMessage(message: "HEY1");
//     debugPrint("$a");

//     for (var p in participants) {
//       a = await _jitsiMeetPlugin.sendChatMessage(to: p, message: "HEY2");
//       debugPrint("$a");
//     }
//   }

//   closeChat() async {
//     await _jitsiMeetPlugin.closeChat();
//   }

//   retrieveParticipantsInfo() async {
//     var a = await _jitsiMeetPlugin.retrieveParticipantsInfo();
//     debugPrint("$a");
//   }
// }
