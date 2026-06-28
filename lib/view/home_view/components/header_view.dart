import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class HeaderView extends StatefulWidget {
  const HeaderView({super.key});

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).padding;
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: Platform.isIOS ? insets.top : insets.top + 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.transparentColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.transparentColor),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset('assets/icons/new_app_icon.png'),
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                data: "Good Evening,",
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              CustomText(
                data: "Rahul 👋",
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),

          const Spacer(),

          IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 24,
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: SvgPicture.asset('assets/svg_icon/notification_icon.svg'),
          ),
        ],
      ),
    );
  }
}
