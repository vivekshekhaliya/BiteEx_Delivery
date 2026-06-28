import 'package:flutter/material.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class OrderNumber extends StatefulWidget {
  const OrderNumber({super.key});

  @override
  State<OrderNumber> createState() => _OrderNumberState();
}

class _OrderNumberState extends State<OrderNumber> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.darkGunmetalColor,
        border: Border.all(color: AppColors.jetGrayColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                data: '#Order-17',
                fontSize: 16,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 6),
              CustomText(
                data: 'Completed at 07 Feb, 9:25 PM',
                fontSize: 13,
                color: AppColors.lightBlueGrayColor,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.orangeColor.withAlpha(40),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomText(
              data: 'In Process',
              fontSize: 10,
              color: AppColors.orangeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
