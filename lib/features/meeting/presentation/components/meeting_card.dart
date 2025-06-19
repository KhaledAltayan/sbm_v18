import 'package:flutter/material.dart';
import 'package:sbm_v18/features/meeting/data/model/meeting_information_model.dart';

class MeetingCard extends StatelessWidget {
  final MeetingInformationModel meeting;

  const MeetingCard({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold, color: primaryColor);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(meeting.title, style: titleStyle),
            const SizedBox(height: 6),

            // Room & Date
            Row(
              children: [
                const Icon(Icons.meeting_room, color: primaryColor, size: 18),
                const SizedBox(width: 6),
                Text("Room: ${meeting.roomId}",
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, color: primaryColor, size: 18),
                const SizedBox(width: 6),
                Text("Start: ${meeting.createdAt}",
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),

            const Divider(height: 24),

            // Creator Info
            Row(
              children: [
                const Icon(Icons.person, color: primaryColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  "Creator: ${meeting.creator.firstName} ${meeting.creator.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Participants Chips
            if (meeting.participants.isNotEmpty) ...[
              const Text(
                "Participants:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: -8,
                children: meeting.participants
                    .map((p) => Chip(
                          label: Text("User ${p.userId}"),
                          backgroundColor: primaryColor.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: 12),

            // Media Section
            if (meeting.media.isNotEmpty) ...[
              const Text(
                "Media:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ...meeting.media.map(
                (m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    m.url,
                    style: const TextStyle(
                        color: primaryColor, decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
