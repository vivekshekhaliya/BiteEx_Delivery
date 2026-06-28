import 'package:bite_ex_delivery/view/verification_view/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../res/components/custom_app_button.dart';
import '../../res/components/custom_app_text_input.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileController = TextEditingController();

  String formatIndianNumber(String input) {
    input = input.replaceAll(RegExp(r'\D'), '');

    if (input.length <= 5) return input;
    if (input.length <= 11) {
      return "${input.substring(0, 5)} ${input.substring(5)}";
    }
    return input.substring(0, 11);
  }

  String cleanNumber(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: padding.top + 10),
              Image.asset('assets/icons/app_icon.png', height: 150, width: 210),
              CustomText(
                data: 'Welcome to the BiteEx 👋',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              CustomText(
                data:
                    'Enter your details to start trading food prices\nin real time.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.lightBlueGrayColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustomAppTextInput(
                controller: mobileController,
                hintText: "Mobile Number",
                keyboardType: TextInputType.phone,
                prefixText: "+91 ",
                maxLength: 11,
                onChanged: (value) {
                  setState(() {});
                  final formatted = formatIndianNumber(value);
                  mobileController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter mobile number";
                  }
                  if (value.length != 11) {
                    return "Mobile number must be 10 digits";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              CustomAppButton(
                text: 'Send OTP',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VerificationScreen(mobile: '1234567890'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialDivider extends StatelessWidget {
  const SocialDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.darkSlateGrayColor, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomText(
            data: "Or continue with",
            color: AppColors.coolGrayColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.darkSlateGrayColor, thickness: 1),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const SocialButton({super.key, required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.darkSlateGrayColor),
        ),
        child: Center(
          child: SvgPicture.asset(assetPath, height: 24, width: 24),
        ),
      ),
    );
  }
}
