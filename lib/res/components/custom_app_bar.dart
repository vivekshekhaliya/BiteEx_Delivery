import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.secondaryColor,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        splashRadius: 20,
        icon: Center(
          child: SvgPicture.asset(
            'assets/svg_icon/arrow_left_icon.svg',
            height: 30,
            width: 30,
          ),
        ),
      ),
      title: CustomText(
        data: title,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.whiteColor,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}