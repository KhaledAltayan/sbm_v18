import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/core/style/app_assets.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';

import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit1.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_state.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/create_meeting_page.dart';

import 'package:sbm_v18/features/meeting/presentation/pages/invite_meet_page.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/m1.dart';

class CreateJoinMeetingPage extends StatelessWidget {
  const CreateJoinMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Column(
                children: [
                  Image.asset(
                    AppAssets.meeting, // Replace with your image path
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Start or Join a Meeting',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a new meeting or join an existing one effortlessly.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(height: 48),

              // Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context2) => BlocProvider.value(
                                  value: BlocProvider.of<MeetingCubit>(context),
                                  child: const CreateMeetingPage(),
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        'New Meet',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context2) => BlocProvider.value(
                        //           value: BlocProvider.of<MeetingCubit1>(
                        //             context,
                        //           ),
                        //           child: JoinMeetingPage(),
                        //         ),
                        //   ),
                        // );
                      },
                      child: const Text(
                        'Join Meet',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
