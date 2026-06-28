import 'package:bite_ex_delivery/res/components/app_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class UserContact extends StatefulWidget {
  const UserContact({super.key});

  @override
  State<UserContact> createState() => _UserContactState();
}

class _UserContactState extends State<UserContact> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCachedNetworkImage(
          imageUrl:
              'https://testingbot.com/free-online-tools/random-avatar/200',
          height: 48,
          width: 48,
          borderRadius: BorderRadius.circular(100),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              data: 'Jack white',
              fontSize: 16,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 6),
            CustomText(
              data: '9999-999-99',
              fontSize: 13,
              color: AppColors.lightBlueGrayColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.jetGrayColor),
            color: AppColors.darkGunmetalColor,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/svg_icon/call_icon.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
      ],
    );
  }
}
