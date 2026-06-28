import 'package:bite_ex_delivery/res/components/app_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class FoodProduct extends StatefulWidget {
  const FoodProduct({super.key});

  @override
  State<FoodProduct> createState() => _FoodProductState();
}

class _FoodProductState extends State<FoodProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.darkGunmetalColor,
        border: Border.all(color: AppColors.jetGrayColor),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => Divider(
          height: 24,
          thickness: 1,
          color: AppColors.darkSlateGrayColor,
        ),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.darkGunmetalColor,
                  border: Border.all(color: AppColors.jetGrayColor, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: AppCachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D',
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    data: 'Regular Dabeli (Oil)',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                  CustomText(
                    data: '2 X ₹35.00',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.coolGrayColor,
                  ),
                ],
              ),
              Spacer(),
              CustomText(
                data: '₹75.00',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
