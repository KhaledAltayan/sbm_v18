import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/invite_meet_page.dart';

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({super.key});

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final TextEditingController _titleController = TextEditingController();
  bool askToJoin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Meeting')),
      body: BlocListener<MeetingCubit, MeetingState>(
        listener: (context, state) {
          if (state.isSuccess == MeetingsIsSuccess.addMeet &&
              state.meet != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Meeting "${state.meet!.title}" created!'),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context2) => BlocProvider.value(
                  value: BlocProvider.of<MeetingCubit>(context),

                  child: InviteMeetPage(meet: state.meet!)),
              ),
            );
          } else if (state.isFailure == MeetingsIsFailure.addMeet) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure!.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ask to Join'),
                  Switch(
                    value: askToJoin,
                    onChanged: (value) =>
                        setState(() => askToJoin = value),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text.trim();
                    if (title.isNotEmpty) {
                      context.read<MeetingCubit>().createMeeting(
                            title: title,
                            startTime: DateTime.now(),
                            askToJoin: askToJoin,
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a title'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  child: const Text('Create Meeting'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
