import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class CompleteVerification extends StatefulWidget {
  const CompleteVerification({super.key});

  @override
  State<CompleteVerification> createState() => _CompleteVerificationState();
}

class _CompleteVerificationState extends State<CompleteVerification> {
  String enteredOtp = "";
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.darkGunmetalColor,
        border: Border.all(color: AppColors.jetGrayColor, width: 1),
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            data: 'Enter OTP',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
            textAlign: TextAlign.center,
          ),

          Pinput(
            length: 4,
            autofocus: false,
            obscureText: false,
            controller: _otpController,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            cursor: Container(
              height: 20,
              width: 2,
              color: AppColors.primaryColor,
            ),
            defaultPinTheme: PinTheme(
              height: 56,
              width: size.width / 5.6,
              textStyle: TextStyle(fontSize: 22, color: AppColors.whiteColor),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkSlateGrayColor),
              ),
            ),
            focusedPinTheme: PinTheme(
              height: 56,
              width: size.width / 5.6,
              textStyle: TextStyle(fontSize: 22, color: AppColors.whiteColor),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryColor),
              ),
            ),

            /// 🔥 IMPORTANT
            onChanged: (value) {
              enteredOtp = value;
            },

            /// 🔥 AUTO SUBMIT (optional but recommended)
            onCompleted: (value) {
              enteredOtp = value;
            },
          ),
        ],
      ),
    );
  }
}
