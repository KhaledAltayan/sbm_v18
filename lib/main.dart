import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbm_v18/core/helpers/user_local_data.dart';
import 'package:sbm_v18/features/auth/data/model/user_information_model.dart';
import 'package:sbm_v18/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sbm_v18/features/home/navigation_page.dart';
import 'package:sbm_v18/features/onboarding/onboarding_page.dart';
import 'package:sbm_v18/features/profile/profile_page.dart';
import 'package:sbm_v18/notification_service.dart';

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

      home:
          userInfo == null
              ? BlocProvider(
                create: (context) => AuthCubit(),
                child: OnboardingPage(),
              )
              : BlocProvider(
                create: (context) => AuthCubit()..loadUserInfo(userInfo!),
                child: NavigationPage(),
              ),
    );
  }
}
