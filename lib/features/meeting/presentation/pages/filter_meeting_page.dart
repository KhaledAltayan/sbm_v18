import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/presentation/components/horizontal_date_picker.dart';
import 'package:sbm_v18/features/meeting/presentation/components/meeting_card.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';

class FilterMeetingPage extends StatelessWidget {
  const FilterMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final meetingCubit = context.read<MeetingCubit>();

    return Scaffold(
      appBar: AppBar(title: Text('Filter Meetings by Date')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              HorizontalDatePicker(
                partName: 'Meeting',
                onDateSelected: (String selectedDate) {
                  // Call Cubit method when date changes
                  meetingCubit.getMeetingsByDate(selectedDate);
                },
              ),

              // Optional: Show filtered meetings list with BlocBuilder
              Expanded(
                child: BlocBuilder<MeetingCubit, MeetingState>(
                  builder: (context, state) {
                    if (state.isLoading == MeetingsIsLoading.getMeetingsByDate) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final meetings = state.allMeetingsByDate;
                    if (meetings.isEmpty) {
                      return const Center(child: Text('No meetings found'));
                    }

                    return ListView.builder(
                      itemCount: meetings.length,
                      itemBuilder: (context, index) {
                        final meeting = meetings[index];
                        return MeetingCard(meeting: meeting);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
