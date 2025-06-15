import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit1.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state1.dart';


class JoinMeetingPage2 extends StatelessWidget {
  JoinMeetingPage2({super.key});

  final TextEditingController _roomIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<MeetingCubit1, MeetingState1>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Request sent successfully")),
              );
              context.read<MeetingCubit1>().resetState();
            } else if (state.failure != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.failure!.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const Text(
                  "Enter Room ID",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _roomIdController,
                  decoration: InputDecoration(
                    hintText: "e.g. team1234",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            final roomId = _roomIdController.text.trim();
                            if (roomId.isNotEmpty) {
                              context.read<MeetingCubit1>().requestToJoin(roomId);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a room ID"),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text("Join"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
