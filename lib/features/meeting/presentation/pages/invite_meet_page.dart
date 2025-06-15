import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _copyRoomId() {
    Clipboard.setData(ClipboardData(text: widget.meet.roomId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room ID copied to clipboard')),
    );
  }

  void _inviteUser() {
    final email = _searchController.text.trim();
    if (email.isNotEmpty && !invitedEmails.contains(email)) {
      setState(() {
        invitedEmails.add(email);
        _searchController.clear();
      });
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetingCubit, MeetingState>(
      listener: (context, state) {
        if (state.isSuccess == MeetingsIsSuccess.uploadRecording) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording uploaded: ${state.recordingUrl}')),
          );
        }
        if (state.isFailure == MeetingsIsFailure.uploadRecording) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${state.failure?.message ?? ''}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Invite to Meeting"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Room ID with Copy
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

              // Search bar
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

              const SizedBox(height: 24),

              // Invited Users List
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
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
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

              // Upload recording button
              ElevatedButton.icon(
                onPressed: _pickAndUploadRecording,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Recording"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
