import 'package:flutter/material.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';
import '../../../model/order_details_model.dart';

class OrderNumber extends StatelessWidget {
  final OrderDetailsData? order;
  const OrderNumber({super.key, this.order});

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.orangeColor;
    final lower = status.toLowerCase();
    if (lower == 'delivered' || lower == 'completed') {
      return AppColors.mintGreenColor;
    } else if (lower == 'on the way' || lower == 'on_the_way') {
      return AppColors.primaryColor;
    }
    return AppColors.orangeColor;
  }

  @override
  Widget build(BuildContext context) {
    final statusText = order?.status ?? 'In Process';
    final statusColor = _getStatusColor(order?.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                data: order?.orderNumber ?? '#ORDER-17',
                fontSize: 16,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              CustomText(
                data: order?.date ?? '',
                fontSize: 13,
                color: AppColors.lightBlueGrayColor,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomText(
              data: statusText,
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
