import 'dart:async';
import 'package:bite_ex_delivery/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../res/components/custom_text.dart';
import '../../res/components/app_custom_flip_text.dart';
import '../../res/components/custom_app_bar.dart';
import '../../res/components/custom_app_button.dart';
import '../../res/constants/app_colors.dart';

class VerificationScreen extends StatefulWidget {
  final String mobile;
  const VerificationScreen({super.key, required this.mobile});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String enteredOtp = "";
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.secondaryColor,
      appBar: CustomAppBar(title: ''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Title
            CustomText(
              data: 'OTP Verification',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor,
              textAlign: TextAlign.center,
            ),

            /// Subtitle
            SizedBox(height: 20),
            CustomText(
              data: 'OTP has been sent to ${widget.mobile}',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.lightBlueGrayColor,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            /// OTP Boxes
            Pinput(
              length: 6,
              controller: _otpController,
              autofocus: true,
              obscureText: false,
              cursor: Container(
                height: 20,
                width: 2,
                color: AppColors.primaryColor,
              ),
              defaultPinTheme: PinTheme(
                height: 56,
                width: size.width / 7,
                textStyle: TextStyle(fontSize: 22, color: AppColors.whiteColor),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.darkSlateGrayColor),
                ),
              ),

              focusedPinTheme: PinTheme(
                height: 56,
                width: size.width / 7,
                textStyle: TextStyle(fontSize: 22, color: AppColors.whiteColor),
                decoration: BoxDecoration(
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
            const SizedBox(height: 40),

            /// Verify Button
            CustomAppButton(
              text: "Verify",
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.bottomNavigationBarScreen,
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 40),

            /// Resend Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  data: 'Resend code in ',
                  color: AppColors.coolGrayColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                if (_secondsRemaining == 0)
                  CustomText()
                else
                  AppCustomFlipText(
                    value: num.parse(
                      _secondsRemaining.toString().padLeft(2, '0'),
                    ),
                    prefix: '00:',
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
