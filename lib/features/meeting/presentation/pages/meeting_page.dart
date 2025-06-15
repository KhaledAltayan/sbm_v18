import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sbm_v18/features/meeting/presentation/components/meeting_card.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/filter_meeting_page.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_detail_page.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({super.key});

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<MeetingCubit>().getMeetings(); // Fetch on open
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meetings")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Search Field (Expanded)
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by meeting name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<MeetingCubit>().searchMeetingsByName(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Filter Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.filter_list),
                    label: const Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(DateTime.now());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context2) => BlocProvider.value(
                                value: BlocProvider.of<MeetingCubit>(context)
                                  ..getMeetingsByDate(formattedDate),
                                child: FilterMeetingPage(),
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MeetingCubit, MeetingState>(
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context2) => BlocProvider.value(
                              
                              value:  BlocProvider.of<MeetingCubit>(context),
                              child: MeetingDetailPage(meeting: meeting)),
                          ),
                        );
                      },
                      child: MeetingCard(meeting: meeting),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
