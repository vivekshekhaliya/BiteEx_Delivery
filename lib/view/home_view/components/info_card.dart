import 'package:flutter/material.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String count;
  const InfoCard({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.darkGunmetalColor,
          border: Border.all(color: AppColors.jetGrayColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            CustomText(
              data: count,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
            CustomText(
              data: label,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
