import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteMeetPage extends StatefulWidget {
  final String roomId;
  const InviteMeetPage({super.key, required this.roomId});

  @override
  State<InviteMeetPage> createState() => _InviteMeetPageState();
}

class _InviteMeetPageState extends State<InviteMeetPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> invitedEmails = [];

  void _copyRoomId() {
    Clipboard.setData(ClipboardData(text: widget.roomId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Room ID copied to clipboard')),
    );
  }

  void _inviteUser() {
    final email = _searchController.text.trim();
    if (email.isNotEmpty && !invitedEmails.contains(email)) {
      setState(() {
        invitedEmails.add(email);
        _searchController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite to Meeting"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Room ID with Copy
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Room ID: ${widget.roomId}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    onPressed: _copyRoomId,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Search bar
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _inviteUser(),
              decoration: InputDecoration(
                hintText: 'Enter email to invite',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: _inviteUser,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),

            const SizedBox(height: 24),

            // Invited Users List
            if (invitedEmails.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: invitedEmails.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final email = invitedEmails[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(email),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() => invitedEmails.removeAt(index));
                        },
                      ),
                    );
                  },
                ),
              )
            else
              const Text(
                "No invited users yet.",
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
