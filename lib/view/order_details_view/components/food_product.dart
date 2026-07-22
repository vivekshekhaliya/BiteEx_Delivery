import 'package:bite_ex_delivery/res/components/app_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/order_details_model.dart';
import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class FoodProduct extends StatelessWidget {
  final List<OrderItem>? items;
  final dynamic amount;
  final dynamic earnings;
  final String? paymentMethod;

  const FoodProduct({
    super.key,
    this.items,
    this.amount,
    this.earnings,
    this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.darkGunmetalColor,
        border: Border.all(color: AppColors.jetGrayColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items != null && items!.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items!.length,
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => Divider(
                height: 24,
                thickness: 1,
                color: AppColors.darkSlateGrayColor,
              ),
              itemBuilder: (context, index) {
                final item = items![index];
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
                          imageUrl: item.image ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=900&auto=format&fit=crop&q=60',
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
                          data: item.productName ?? 'Product',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        ),
                        CustomText(
                          data: '${item.quantity ?? 1} X ₹${item.price ?? 0}',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.coolGrayColor,
                        ),
                      ],
                    ),
                    Spacer(),
                    CustomText(
                      data: '₹${item.total ?? 0}',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor,
                    ),
                  ],
                );
              },
            ),
          
          if (amount != null || earnings != null) ...[
            Divider(height: 24, thickness: 1, color: AppColors.darkSlateGrayColor),
            if (paymentMethod != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(data: 'Payment Method', fontSize: 14, color: AppColors.coolGrayColor),
                    CustomText(data: paymentMethod!, fontSize: 14, color: AppColors.whiteColor, fontWeight: FontWeight.w500),
                  ],
                ),
              ),
            if (amount != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(data: 'Total Amount', fontSize: 14, color: AppColors.coolGrayColor),
                    CustomText(data: '₹$amount', fontSize: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            if (earnings != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(data: 'Delivery Earnings', fontSize: 14, color: AppColors.coolGrayColor),
                  CustomText(data: '₹$earnings', fontSize: 16, color: AppColors.mintGreenColor, fontWeight: FontWeight.w600),
                ],
              ),
          ]
        ],
      ),
    );
  }
}
