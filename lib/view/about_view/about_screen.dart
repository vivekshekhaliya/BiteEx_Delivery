import 'package:flutter/material.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../../res/components/custom_app_bar.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  VersionStatus? version;

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    final newVersion = NewVersionPlus();
    final status = await newVersion.getVersionStatus();

    setState(() {
      version = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: CustomAppBar(title: 'About Bite EX'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/about_image.png',
              width: double.infinity,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    data: 'Welcome to a smarter way to order food 🍔',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(height: 16),
                  infoCard(
                    'Introduction',
                    'With over three decades of experience in the food industry, we bring deep-rooted expertise and a proven track record of success. Our journey includes building and operating Kutchi King for more than 20 years—a brand that has earned immense trust and love from its customers. Over the years, we have proudly served more than 50 million customers and sold over 200 million Dabelis, our signature and most loved product.',
                  ),
                  SizedBox(height: 16),
                  infoCard(
                    'Our Vision',
                    'At Biteex, our vision is to create a strong and recognizable brand by redefining local street food. We aim to serve the most loved and in-demand street food with a premium touch, ensuring excellence in every aspect—be it packaging, presentation, hygiene, ambiance, or customer service. Our goal is to elevate everyday street food into a refined and memorable experience.',
                  ),
                  SizedBox(height: 16),
                  infoCard(
                    'Our Mission',
                    'Our mission goes beyond food—we strive to empower people. At Biteex, we aim to provide individuals with an opportunity to grow, learn, and become a better version of themselves. By fostering a collaborative and growth-oriented environment, we encourage people who are willing to improve and evolve into individuals who achieve meaningful success in life.',
                  ),
                  SizedBox(height: 16),
                  infoCard(
                    'What We Offer',
                    'We are committed to delivering not just great food, but also exceptional value and convenience:',
                  ),
                  SizedBox(height: 16),
                  infoCard(
                    'Direct Delivery System:',
                    'Our in-house delivery model eliminates dependency on third-party platforms that often increase food prices and lack reliable customer support. This ensures better pricing and a smoother experience for our customers.',
                  ),
                  SizedBox(height: 16),
                  infoCard(
                    'Rewarding Loyalty Program:',
                    'Our loyalty program is designed to go beyond standard offers. It gives our valued customers a unique opportunity to enjoy meals for free by engaging with and supporting their favorite brand —Biteex',
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    data: '🚀 Join the Bite EX experience',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    data:
                        'Where swaad meets smart ordering and prices move live!',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: CustomText(
                      data: 'App Version v${version?.storeVersion}',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.coolGrayColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String label, String subLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          data: label,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.whiteColor,
        ),
        SizedBox(height: 8),
        CustomText(
          data: subLabel,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.whiteColor,
        ),
      ],
    );
  }
}
