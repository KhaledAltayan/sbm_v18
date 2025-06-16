import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class TranslationPage extends StatefulWidget {
  final String transcribedText;

  const TranslationPage({super.key, required this.transcribedText});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<MeetingCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("Transcription Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Transcript:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.transcribedText, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MeetingCubit>().summarizeMeeting(
                  query: 'لخص الاجتماع',
                  document: widget.transcribedText,
                );
              },
              icon: const Icon(Icons.summarize),
              label: const Text("Summarization (Default Query)"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Enter your query',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                final query = _queryController.text.trim();
                if (query.isNotEmpty) {
                  context.read<MeetingCubit>().summarizeMeeting(
                    query: query,
                    document: widget.transcribedText,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a query.')),
                  );
                }
              },
              icon: const Icon(Icons.question_answer),
              label: const Text("Summarize with Query"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<MeetingCubit, MeetingState>(
              builder: (context, state) {
                if (state.isLoading == MeetingsIsLoading.summarizeMeeting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.summaryText != null &&
                    state.summaryText!.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Summary:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.summaryText!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                } else if (state.isFailure ==
                        MeetingsIsFailure.summarizeMeeting &&
                    state.failure != null) {
                  return Text(
                    "Failed to summarize: ${state.failure!.message}",
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
