import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_state.dart';
import 'package:sbm_v18/features/auth/presentation/pages/login_page.dart';
import 'package:sbm_v18/features/auth/presentation/pages/register_page.dart';
import 'package:sbm_v18/features/home/navigation_page.dart';
import 'package:sbm_v18/features/meeting/data/data_source/meeting_remote_data_source.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page2.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page4.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page5.dart';
import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page6.dart';
import 'package:sbm_v18/features/onboarding/onboarding_page.dart';
import 'package:sbm_v18/features/profile/profile_page.dart';
import 'package:sbm_v18/firebase_options.dart';

import 'package:sbm_v18/home.dart';

import 'package:sbm_v18/my_home_page.dart';
import 'package:sbm_v18/notification2.dart';
import 'package:sbm_v18/notification_service.dart';
import 'package:sbm_v18/notifigation_page.dart';
import 'package:sbm_v18/puseh55.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.instance.initialize();
  final userInfo = await UserLocalData.getUserInfo();
  runApp(MyApp(userInfo: userInfo));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userInfo});
  final UserInformationModel? userInfo;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Business Meeting',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // home: const MyHomePage(title: 'Jitsi Meet Flutter SDK Sample'),
      // home: Home(),
      // home: BlocProvider(
      //   create:
      //       (_) =>
      //           MeetingCubit()..getMeetings(),
      //   child: MeetingsPage(),
      // ),
        // home: BlocProvider(
        //   create: (context) => MeetingCubit(remote: MeetingRemoteDataSource()),
        //   child: MeetingPage2()),
      // home: MeetingPage4(),
      // home: MeetingPage5(),
      // home: MeetingPage6(),
      // home: NotificationPage(),
      // home: NotificationPage2(),

      // home: BlocProvider(
      //   create: (context) => AuthCubit(),
      //   child: RegisterPage()),

      //   home: BlocProvider(
      //     create: (context) => AuthCubit(),
      //     child: LoginPage()),

      /************************************************************************ */
      // home:
      //     userInfo == null
      //         ? BlocProvider(
      //           // create: (_) => AuthCubit(),
      //           create: (context) => AuthCubit(),
      //           child: OnboardingPage(),
      //         )
      //         : BlocProvider(
      //           // create: (_) {
      //           //   final cubit = AuthCubit();
      //           //   cubit.loadUserInfo(userInfo!); // ✅ use the public method
      //           //   return cubit;
      //           // },
      //           create: (context) => AuthCubit()..loadUserInfo(userInfo!),
      //           child: ProfilePage(),
      //         ),

      /************************************************************************ */
      home: NavigationPage(),
      // home: PusherTestPage(),
    );
  }
}
