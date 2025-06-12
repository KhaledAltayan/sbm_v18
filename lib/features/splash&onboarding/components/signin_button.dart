import 'package:flutter/material.dart';
import 'package:sbm_v18/core/style/app_color.dart';
import 'package:sbm_v18/core/style/app_text_styles.dart';

class SigninButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SigninButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.blueRibbon,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              offset: const Offset(0, 5),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(text, style: AppTextStyles.latoAlabasterBold16),
      ),
    );
  }
}
