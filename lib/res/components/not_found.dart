import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_colors.dart';
import 'custom_text.dart';

class NotFound extends StatelessWidget {
  final String? title;
  final double? height;
  const NotFound({super.key, this.title, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        children: [
          SizedBox(height: height ?? 120),
          Lottie.asset(
            'assets/lotties/not_found.json',
            height: 120,
            width: 120,
          ),
          SizedBox(height: 16),
          CustomText(
            data: title ?? 'No data found!',
            fontSize: 18,
            color: AppColors.lightBlueGrayColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
