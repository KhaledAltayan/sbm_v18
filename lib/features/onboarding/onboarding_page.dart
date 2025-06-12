import 'package:flutter/material.dart';
import 'package:sbm_v18/core/style/app_assets.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/core/style/app_text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/signin_button.dart';
import 'dart:async';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  Timer? _autoScrollTimer;

  final List<Map<String, dynamic>> pages = [
    {
      'image': AppAssets.team2,
      'title': 'Seamless Team Meetings',
      'subtitle':
          "Connect with your team anytime, anywhere, effortlessly and securely.",
    },
    {
      'image': AppAssets.team1,
      'title': 'Smart Collaboration',
      'subtitle':
          'Share ideas, stay organized, and work together in real-time.',
    },
    {
      'image': AppAssets.aiSummarization,
      'title': 'AI-Powered Summaries',
      'subtitle':
          'Let AI capture key points and action items from every meeting.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_controller.hasClients) return;

      int nextPage = currentIndex + 1;
      if (nextPage >= pages.length) {
        nextPage = 0;
      }

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              // flex: 6,
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);

                  _autoScrollTimer?.cancel();
                  _startAutoScroll();
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        // flex: 8,
                        child: Image.asset(
                          pages[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      // SizedBox(height: 20),
                      Text(
                        pages[index]['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.latoWoodSmokeBold20,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          pages[index]['subtitle'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.latoScarpaFlow14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Page Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: pages.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColor.blueRibbon,
                dotColor: AppColor.iron,
              ),
            ),

            const SizedBox(height: 50),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SigninButton(text: 'Sign In', onTap: () {}),

                  const SizedBox(height: 16),

                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: BorderSide(color: AppColor.blueRibbon, width: 1),
                    ),
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.latoBlueRibbonBold16,
                    ),
                  ),

                  const SizedBox(height: 64),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
