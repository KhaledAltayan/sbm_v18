import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/features/meeting/data/data_source/meeting_remote_data_source.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page.dart';
import 'package:sbm_v18/home.dart';

import 'package:sbm_v18/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jitsi Meet Flutter SDK Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // home: const MyHomePage(title: 'Jitsi Meet Flutter SDK Sample'),
      // home: Home(),
      home: BlocProvider(
        create:
            (_) =>
                MeetingCubit(remote: MeetingRemoteDataSource())..getMeetings(),
        child: MeetingsPage(),
      ),
    );
  }
}
