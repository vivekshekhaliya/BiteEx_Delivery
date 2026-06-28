import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
        SizedBox(width: 16),
        CustomText(
          data: 'My Profile',
          color: AppColors.whiteColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        Spacer(),
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 24,
          constraints: const BoxConstraints(),
          onPressed: () {},
          icon: SvgPicture.asset('assets/svg_icon/notification_icon.svg'),
        ),
      ],
    );
  }
}
