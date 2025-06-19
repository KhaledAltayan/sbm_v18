import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/presentation/components/horizontal_date_picker.dart';
import 'package:sbm_v18/features/meeting/presentation/components/meeting_card.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_detail_page.dart';

class FilterMeetingPage extends StatelessWidget {
  const FilterMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final meetingCubit = context.read<MeetingCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Filter Meetings by Date'),
        backgroundColor: Colors.blue.shade800,
        elevation: 2,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              HorizontalDatePicker(
                partName: 'Meeting',
                onDateSelected: (String selectedDate) {
                  // Call Cubit method when date changes
                  meetingCubit.getMeetingsByDate(selectedDate);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<MeetingCubit, MeetingState>(
                  builder: (context, state) {
                    if (state.isLoading == MeetingsIsLoading.getMeetingsByDate) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }

                    final meetings = state.allMeetingsByDate;
                    if (meetings.isEmpty) {
                      return Center(
                        child: Text(
                          'No meetings found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: meetings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final meeting = meetings[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context2) => BlocProvider.value(
                                  value: BlocProvider.of<MeetingCubit>(context),
                                  child: MeetingDetailPage(meeting: meeting),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade100.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: MeetingCard(meeting: meeting),
                          ),
                        );
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
