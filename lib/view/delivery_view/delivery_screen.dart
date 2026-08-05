import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../res/components/app_cached_network_image.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';
import '../../view_model/rider_view_model.dart';
import 'components/delivery_header.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RiderViewModel>(
        context,
        listen: false,
      ).getRiderHistoryApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light, // Android: light icons (white)
        statusBarBrightness:
            Brightness.dark, // iOS: dark background = light (white) text
        systemNavigationBarColor: AppColors.secondaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final riderVM = Provider.of<RiderViewModel>(context);
    final historyList = riderVM.historyData?.data;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const DeliveryHeader(),
        backgroundColor: AppColors.secondaryColor,
      ),

      body: riderVM.historyLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : historyList == null || historyList.isEmpty
          ? Center(
              child: CustomText(
                data: "No delivery history found",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.lightBlueGrayColor,
              ),
            )
          : ListView.builder(
              itemCount: historyList.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              itemBuilder: (context, index) {
                final order = historyList[index];
                final pickupText =
                    (order.pickupLocation != null &&
                        order.pickupLocation!.isNotEmpty)
                    ? "${order.pickupName ?? ''} - ${order.pickupLocation}"
                    : (order.pickupName ?? '');
                final isDelivered = order.status == 'Completed';
                final statusColor = isDelivered
                    ? AppColors.primaryColor
                    : AppColors.orangeColor;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGunmetalColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  data: "Pickup :",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.whiteColor,
                                ),
                                CustomText(
                                  data: pickupText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.whiteColor,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  data: "Drop :",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.whiteColor,
                                ),
                                CustomText(
                                  data: order.dropLocation ?? '',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.whiteColor,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 0.6,
                        color: AppColors.darkSlateGrayColor,
                      ),
                      Row(
                        children: [
                          CustomText(
                            data: '₹${order.deliveryEarnings ?? 0}',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightBlueGrayColor,
                          ),
                          const SizedBox(width: 10),
                          const CustomText(
                            data: '•',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkSlateGrayColor,
                          ),
                          const SizedBox(width: 10),
                          CustomText(
                            data: order.date ?? '',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightBlueGrayColor,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: statusColor.withAlpha(40),
                            ),
                            child: CustomText(
                              data: order.status ?? 'Delivered',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      CustomText(
                        data: order.orderNumber?.startsWith('#') == true
                            ? (order.orderNumber ?? '')
                            : '#${order.orderNumber ?? ''}',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightBlueGrayColor,
                      ),
                      if (order.productImages != null &&
                          order.productImages!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 44,
                          child: ListView.builder(
                            itemCount: order.productImages!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, imgIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: AppCachedNetworkImage(
                                  imageUrl: order.productImages![imgIndex],
                                  height: 44,
                                  width: 44,
                                  borderRadius: BorderRadius.circular(4),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
