import 'package:flutter/material.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_model.dart';

class MeetingCard extends StatelessWidget {
  final MeetingModel meeting;

  const MeetingCard({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meeting.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text("Room: ${meeting.roomId}", style: TextStyle(color: Colors.grey[600])),
            Text("Start: ${meeting.startTime}", style: TextStyle(color: Colors.grey[600])),
            Text("Duration: ${meeting.duration} hrs", style: TextStyle(color: Colors.grey[600])),

            const Divider(height: 24),

            Text("Creator: ${meeting.creator.firstName} ${meeting.creator.lastName}",
                style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: meeting.participants.map((p) => Chip(label: Text("User ${p.userId}"))).toList(),
            ),

            const SizedBox(height: 8),
            if (meeting.media.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Media:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...meeting.media.map((m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(m.url, style: TextStyle(color: Colors.blue)),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
