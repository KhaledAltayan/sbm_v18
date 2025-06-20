import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class VoiceSeparationPage extends StatefulWidget {
  final List<String> transcripts;

  const VoiceSeparationPage({super.key, required this.transcripts});

  @override
  State<VoiceSeparationPage> createState() => _VoiceSeparationPageState();
}

class _VoiceSeparationPageState extends State<VoiceSeparationPage> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blueColor = Colors.blue.shade700;
    final document = widget.transcripts.join('\n');

    return Scaffold(
      appBar: AppBar(
        title:  Text("Voice Separation",style: TextStyle(color: AppColor.white),),
        backgroundColor: blueColor,
        elevation: 2,
        iconTheme: IconThemeData(color: AppColor.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Separated Voice Transcript:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.transcripts.map((t) => Card(
              color: Colors.blue[100],
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              shadowColor: blueColor.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  t,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            )),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                context.read<MeetingCubit>().summarizeMeeting(
                      query: 'نقاط رئيسية' ,
                      document: document,
                    );
              },
              icon: const Icon(Icons.summarize),
              label: const Text(
                "Summarization (Default Query)",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                labelText: 'Enter your query',
                labelStyle: TextStyle(color: blueColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: blueColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: blueColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              cursorColor: blueColor,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                final query = _queryController.text.trim();
                if (query.isNotEmpty) {
                  context.read<MeetingCubit>().summarizeMeeting(
                        query: query,
                        document: document,
                      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a query.')),
                  );
                }
              },
              icon: const Icon(Icons.question_answer),
              label: const Text(
                "Summarize with Query",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 32),

            BlocBuilder<MeetingCubit, MeetingState>(
              builder: (context, state) {
                if (state.isLoading == MeetingsIsLoading.summarizeMeeting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.summaryText != null &&
                    state.summaryText!.isNotEmpty) {
                  return Card(
                    color: Colors.blue[100],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    shadowColor: blueColor.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Summary:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.summaryText!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state.isFailure ==
                        MeetingsIsFailure.summarizeMeeting &&
                    state.failure != null) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Failed to summarize: ${state.failure!.message}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
