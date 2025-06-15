// meeting_detail_page.dart

import 'package:flutter/material.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';

class MeetingDetailPage extends StatelessWidget {
  final MeetingInformationModel meeting;

  const MeetingDetailPage({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meeting.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${meeting.title}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text("Start Time: ${meeting.startTime}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text("Meeting ID: ${meeting.id}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text("Ask to Join: ${meeting.askToJoin==1 ? "Yes" : "No"}", style: const TextStyle(fontSize: 16)),
            // Add more fields as needed
          ],

          
        ),
      ),
    );
  }
}
