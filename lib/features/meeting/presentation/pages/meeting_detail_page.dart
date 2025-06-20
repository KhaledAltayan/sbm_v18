import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/translation_page.dart';

class MeetingDetailPage extends StatelessWidget {
  final MeetingInformationModel meeting;

  const MeetingDetailPage({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    final themeBlue = Colors.blue.shade800;

    return BlocConsumer<MeetingCubit, MeetingState>(
      listener: (context, state) {
        if (state.isSuccess == MeetingsIsSuccess.transcribeRecording) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context2) => BlocProvider.value(
                value: BlocProvider.of<MeetingCubit>(context),
                child: TranslationPage(
                  transcribedText: state.transcribedText ?? 'No transcription available',
                ),
              ),
            ),
          );
        } else if (state.isFailure == MeetingsIsFailure.transcribeRecording) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure!.message)),
          );
        } else if (state.isSuccess == MeetingsIsSuccess.voiceSeparation) {
          final transcript = state.transcriptTexts ?? [];
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Voice Separation Result'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: transcript.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(transcript[index]),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        } else if (state.isFailure == MeetingsIsFailure.voiceSeparation) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure!.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(meeting.title),
            backgroundColor: themeBlue,
            centerTitle: true,
            elevation: 3,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(
                    title: 'Meeting Info',
                    children: [
                      _InfoRow(label: 'Title', value: meeting.title),
                      _InfoRow(label: 'Start Time', value: meeting.startTime.toLocal().toString()),
                      _InfoRow(label: 'Meeting ID', value: meeting.id.toString()),
                      _InfoRow(label: 'Ask to Join', value: meeting.askToJoin == 1 ? 'Yes' : 'No'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _InfoCard(
                    title: 'Creator',
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(meeting.creator.media),
                          backgroundColor: Colors.blue.shade100,
                        ),
                        title: Text(
                          '${meeting.creator.firstName} ${meeting.creator.lastName}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Email: ${meeting.creator.email}'),
                            Text('Phone: ${meeting.creator.phoneNumber}'),
                            Text('Address: ${meeting.creator.address}'),
                            Text('Birthday: ${meeting.creator.birthday.toLocal().toIso8601String().split("T").first}'),
                            Text('Gender: ${meeting.creator.gender}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _InfoCard(
                    title: 'Participants (${meeting.participants.length})',
                    children: meeting.participants.isEmpty
                        ? [const Text('No participants')]
                        : meeting.participants.map((p) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(p.user.media),
                                backgroundColor: Colors.blue.shade100,
                              ),
                              title: Text('${p.user.firstName} ${p.user.lastName}'),
                              subtitle: Text(p.user.email),
                            );
                          }).toList(),
                  ),
                  const SizedBox(height: 16),

                  _InfoCard(
                    title: 'Media Files',
                    children: meeting.media.isEmpty
                        ? [const Text("No recordings available.")]
                        : meeting.media.map(
                            (media) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 3,
                              shadowColor: Colors.blue.shade100,
                              child: ListTile(
                                title: Text("Recording ${media.id}"),
                                subtitle: Text(media.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (state.isLoading == MeetingsIsLoading.transcribeRecording)
                                      const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                                      )
                                    else
                                      IconButton(
                                        icon: Icon(Icons.translate, color: themeBlue),
                                        tooltip: 'Transcribe',
                                        onPressed: () {
                                          context.read<MeetingCubit>().transcribeMeeting(meetingId: meeting.id);
                                        },
                                      ),
                                    const SizedBox(width: 8),
                                    if (state.isLoading == MeetingsIsLoading.voiceSeparation)
                                      const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                                      )
                                    else
                                      IconButton(
                                        icon: Icon(Icons.hearing, color: themeBlue),
                                        tooltip: 'Voice Separation',
                                        onPressed: () {
                                          // context.read<MeetingCubit>().voiceSeparation(meetingId: meeting.id);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final themeBlue = Colors.blue.shade800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeBlue,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final themeBlue = Colors.blue.shade800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: themeBlue,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
