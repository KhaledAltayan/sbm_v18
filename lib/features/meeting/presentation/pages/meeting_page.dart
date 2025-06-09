import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/presentation/components/meeting_card.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meetings")),
      body: BlocBuilder<MeetingCubit, MeetingState>(
        builder: (context, state) {
          if (state.isLoading == MeetingsIsLoading.meetings) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.meetings.isEmpty) {
            return const Center(child: Text("No meetings found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.meetings.length,
            itemBuilder: (context, index) {
              final meeting = state.meetings[index];
              return MeetingCard(meeting: meeting);
            },
          );
        },
      ),
    );
  }
}
