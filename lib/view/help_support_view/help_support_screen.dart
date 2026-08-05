import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/components/custom_app_bar.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: CustomAppBar(title: 'Help & Support'),
      body: Column(
        children: [
          customButton(
            'assets/svg_icon/mail_icon.svg',
            'Email',
            'info@biteexchange.com',
            () {
              launchUrl(Uri.parse('mailto:info@biteexchange.com'));
            },
          ),
          customButton(
            'assets/svg_icon/call_fill_icon.svg',
            'Contact Number',
            '+91 99981 31007',
            () {
              launchUrl(Uri.parse('tel:+919998131007'));
            },
          ),
        ],
      ),
    );
  }

  Widget customButton(
    String assetName,
    String title,
    String subTitle,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkGunmetalColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.jetGrayColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(child: SvgPicture.asset(assetName)),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    data: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightBlueGrayColor,
                  ),
                  SizedBox(height: 2),
                  CustomText(
                    data: subTitle,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.coolGrayColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
