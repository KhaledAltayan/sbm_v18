import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbm_v18/core/style/app_assets.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/features/meeting/presentation/components/meeting_card.dart';
import 'package:sbm_v18/features/meeting/presentation/manager/meeting_cubit.dart';

import 'package:sbm_v18/features/meeting/presentation/pages/meeting_page.dart';

import 'package:sbm_v18/features/meeting/presentation/pages/create_join_meeting_page.dart';
import 'package:sbm_v18/features/profile/profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  List<Widget> body = [
    BlocProvider(
      create: (context) => MeetingCubit()..getMeetings(),
      child: MeetingsPage(),
    ),
    BlocProvider(
      create: (context) => MeetingCubit(),
      child: CreateJoinMeetingPage(),
    ),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: body[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.white : AppColor.shark,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                AppAssets.meetIcon1,
                colorFilter: ColorFilter.mode(
                  _currentIndex == 1 ? Colors.white : AppColor.shark,
                  BlendMode.srcIn,
                ),
              ),
            ),
            label: 'Meeting',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 2 ? Colors.white : AppColor.shark,
            ),
            label: 'Profile',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        // surfaceTintColor: Colors.purple,
        backgroundColor: AppColor.white,

        // height: 80,
        // elevation: 10,
        // shadowColor: Colors.purple,
        animationDuration: const Duration(milliseconds: 300),
        // indicatorColor: Color(0xff8E6CEF),
        indicatorColor: AppColor.blueColor,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
