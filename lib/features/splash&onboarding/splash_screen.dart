import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbm_v18/core/style/app_assets.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/core/style/app_text_styles.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.athensGray,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          SvgPicture.asset(AppAssets.appLogoIcon),

          const Spacer(),

          Text(
            "Meeting Point",
            style: AppTextStyles.latoWoodSmokeBold26,
            textAlign: TextAlign.center,
          ),

          Text(
            "Dreams and teams work together.",
            style: AppTextStyles.latoScarpaFlow16,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 42),
        ],
      ),
    );
  }
}
