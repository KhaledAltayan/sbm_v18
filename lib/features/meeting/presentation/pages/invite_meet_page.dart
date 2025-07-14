import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class InviteMeetPage extends StatefulWidget {
  final MeetingInformationModel meet;

  const InviteMeetPage({super.key, required this.meet});

  @override
  State<InviteMeetPage> createState() => _InviteMeetPageState();
}

class _InviteMeetPageState extends State<InviteMeetPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> invitedEmails = [];

  final AudioRecorder recorder = AudioRecorder();

  String? recordingPath;

  void _copyRoomId() {
    Clipboard.setData(ClipboardData(text: widget.meet.roomId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room ID copied to clipboard')),
    );
  }

  void _inviteUser() {
    final email = _searchController.text.trim();
    if (email.isNotEmpty) {
      context.read<AuthCubit>().searchUserByEmail(email);
    }
  }

  void _pickAndUploadRecording() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3', 'm4a'],
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      if (!mounted) return;
      context.read<MeetingCubit>().uploadRecording(
        meetingId: widget.meet.id,
        filePath: filePath,
      );
    }
  }

  final JitsiMeet jitsiMeet = JitsiMeet();

  // void joinAsAdmin(String room)async {
  //    await startRecording(room);
  //   final options = JitsiMeetConferenceOptions(
  //     serverURL: "https://meet.ffmuc.net/",
  //     room: room,
  //     userInfo: JitsiMeetUserInfo(displayName: "Admin"),
  //     featureFlags: {
  //       FeatureFlags.meetingNameEnabled: true,
  //       FeatureFlags.kickOutEnabled: true,
  //       FeatureFlags.videoShareEnabled: false,
  //       FeatureFlags.securityOptionEnabled: false,
  //       FeatureFlags.meetingPasswordEnabled: false,
  //       FeatureFlags.preJoinPageEnabled: false,
  //       FeatureFlags.replaceParticipant: false,
  //       FeatureFlags.lobbyModeEnabled: false,
  //       FeatureFlags.unsafeRoomWarningEnabled: false,
  //       FeatureFlags.raiseHandEnabled: true,
  //       FeatureFlags.inviteEnabled: false,
  //       FeatureFlags.carModeEnabled: false,
  //       FeatureFlags.addPeopleEnabled: false,
  //       FeatureFlags.speakerStatsEnabled: true,
  //       FeatureFlags.recordingEnabled: true,
  //     },
  //     configOverrides: {
  //       "startWithAudioMuted": false,
  //       "startWithVideoMuted": false,
  //       "disableDeepLinking": true,
  //       "disableThirdPartyRequests": true,
  //       "subject": "Smart Business Meeting",
  //     },
  //   );
  //   jitsiMeet.join(options);
  // }

  void joinAsAdmin(String room) async {
    await startRecording(room);
    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.ffmuc.net/",
      room: room,
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
      userInfo: JitsiMeetUserInfo(displayName: "Admin"),
    );
    jitsiMeet.join(options);
  }

  Future<void> requestPermissions() async {
    await [
      Permission.microphone,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
  }

  Future<void> startRecording(String room) async {
    await requestPermissions();

    if (await recorder.hasPermission()) {
      if (recordingPath == null) {
        Directory downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory('/storage/emulated/0/Download');
        } else {
          downloadsDir =
              await getDownloadsDirectory() ??
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✔️ تم حفظ التسجيل في: $path")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MeetingCubit, MeetingState>(
          listener: (context, state) {
            if (state.isSuccess == MeetingsIsSuccess.uploadRecording) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Recording uploaded: ${state.recordingUrl}'),
                ),
              );
            }
            if (state.isFailure == MeetingsIsFailure.uploadRecording) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Upload failed: ${state.failure?.message ?? ''}',
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.isSuccess == AuthIsSuccess.searchSuccess &&
                state.searchedUser != null) {
              final email = state.searchedUser!.user.email;
              if (!invitedEmails.contains(email)) {
                setState(() {
                  invitedEmails.add(email);
                  _searchController.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'User "${state.searchedUser!.user.firstName}" invited',
                    ),
                  ),
                );

                context.read<MeetingCubit>().inviteUserByCreator(
                  userId: state.searchedUser!.user.id,
                  meetingId: widget.meet.id,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User already invited')),
                );
              }
            } else if (state.isFailure == AuthIsFailure.searchFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure?.message ?? 'User not found'),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          title: const Text("Invite to Meeting"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,

          iconTheme: IconThemeData(color: AppColor.white),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Room ID: ${widget.meet.roomId}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blue),
                      onPressed: _copyRoomId,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _searchController,
                onSubmitted: (_) => _inviteUser(),
                decoration: InputDecoration(
                  hintText: 'Enter email to invite',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: _inviteUser,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (context.watch<AuthCubit>().state.isLoading ==
                  AuthIsLoading.searchingUser)
                // const Padding(
                //   padding: EdgeInsets.only(bottom: 16),
                //   child: CircularProgressIndicator(),
                // ),

              const SizedBox(height: 8),

              if (invitedEmails.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    itemCount: invitedEmails.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final email = invitedEmails[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(email),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() => invitedEmails.removeAt(index));
                          },
                        ),
                      );
                    },
                  ),
                )
              else
                const Text(
                  "No invited users yet.",
                  style: TextStyle(color: Colors.grey),
                ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {
                  // Call the joinAsAdmin function with the room ID
                  joinAsAdmin(widget.meet.roomId);
                },
                icon: const Icon(Icons.video_call),
                label: const Text("Join Meeting"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _pickAndUploadRecording,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Recording"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: stopRecording,
                child: Text(
                  "🛑 Stop recording and Save",
                  style: TextStyle(color: AppColor.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
