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
    return BlocConsumer<MeetingCubit, MeetingState>(
      listener: (context, state) {
        // Transcribe success
        if (state.isSuccess == MeetingsIsSuccess.transcribeRecording) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context2) => BlocProvider.value(
                value: BlocProvider.of<MeetingCubit>(context),
                child: TranslationPage(
                  transcribedText: state.transcribedText ?? 'No thing Translate',
                ),
              ),
            ),
          );
        }

        // Transcribe failure
        else if (state.isFailure == MeetingsIsFailure.transcribeRecording) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure!.message)),
          );
        }

        // Voice separation success
        else if (state.isSuccess == MeetingsIsSuccess.voiceSeparation) {
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
        }

        // Voice separation failure
        else if (state.isFailure == MeetingsIsFailure.voiceSeparation) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure!.message)),
          );
        }
      },
      builder: (context, state) {
        // final cubit = context.read<MeetingCubit>();

        return Scaffold(
          appBar: AppBar(title: Text(meeting.title)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title: ${meeting.title}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text("Start Time: ${meeting.startTime}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Text("Meeting ID: ${meeting.id}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Text("Ask to Join: ${meeting.askToJoin == 1 ? "Yes" : "No"}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  const Text("Media Files:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  if (meeting.media.isEmpty)
                    const Text("No recordings available."),

                  ...meeting.media.map(
                    (media) => Card(
                      child: ListTile(
                        title: Text("Recording ${media.id}"),
                        subtitle: Text(media.url),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Transcribe button
                            state.isLoading == MeetingsIsLoading.transcribeRecording
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.translate),
                                    tooltip: 'Transcribe',
                                    onPressed: () {
                                      context.read<MeetingCubit>().transcribeMeeting(meetingId: meeting.id);
                                    },
                                  ),

                            const SizedBox(width: 8),

                            // Voice separation button
                            state.isLoading == MeetingsIsLoading.voiceSeparation
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.hearing),
                                    tooltip: 'Voice Separation',
                                    onPressed: () {
                                      context.read<MeetingCubit>().voiceSeparation(meetingId: meeting.id);
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
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
