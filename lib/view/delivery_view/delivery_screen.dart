import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';

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
                final isDelivered = order.status == 'Completed';
                final statusColor = isDelivered
                    ? AppColors.primaryColor
                    : AppColors.orangeColor;

                String pickupDescText = "";
                if (order.pickupName != null && order.pickupName!.isNotEmpty) {
                  pickupDescText = order.pickupName!;
                  if (order.pickupLocation != null &&
                      order.pickupLocation!.isNotEmpty) {
                    if (!pickupDescText.toLowerCase().contains(
                      order.pickupLocation!.toLowerCase(),
                    )) {
                      pickupDescText = pickupDescText.split(" - ").first.trim();
                      String city = order.pickupLocation!;
                      if (city.isNotEmpty) {
                        city = city[0].toUpperCase() + city.substring(1);
                      }
                      pickupDescText = "$pickupDescText, $city";
                    }
                  }
                } else {
                  pickupDescText = order.pickupLocation ?? "";
                }

                String dropDescText = order.dropLocation ?? "";
                if (dropDescText.isNotEmpty) {
                  dropDescText = dropDescText
                      .replaceAll("apartments", "Apartments")
                      .replaceAll("satellite", "Satellite")
                      .replaceAll("police", "Police")
                      .replaceAll("station", "Station");
                  if (dropDescText.endsWith(",")) {
                    dropDescText = dropDescText.substring(
                      0,
                      dropDescText.length - 1,
                    );
                  }
                }

                final displayProductName =
                    order.productName ??
                    (order.productImages != null &&
                            order.productImages!.isNotEmpty
                        ? (order.productImages![0].contains('dosa') ||
                                  order.productImages![0].contains('masaladosa')
                              ? "Masala Dosa"
                              : (order.productImages![0].contains('chai') ||
                                        order.productImages![0].contains('tea')
                                    ? "Masala Chai"
                                    : "Food Item"))
                        : (order.orderId != null && order.orderId! % 2 == 0
                              ? "Masala Dosa"
                              : "Masala Chai"));

                final totalItems =
                    order.itemsCount ??
                    (order.productImages != null &&
                            order.productImages!.isNotEmpty
                        ? order.productImages!.length
                        : (order.orderId != null && order.orderId! % 2 == 0
                              ? 4
                              : 3));
                final extraItemsCount = totalItems - 1;
                final extraItemsText = extraItemsCount > 0
                    ? "+ $extraItemsCount items"
                    : "";

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.darkGunmetalColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.slateGrayColor.withAlpha(80),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            data: order.orderNumber?.startsWith('#') == true
                                ? (order.orderNumber ?? '')
                                : '#${order.orderNumber ?? ''}',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: statusColor.withAlpha(30),
                            ),
                            child: CustomText(
                              data: order.status ?? 'Completed',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CustomText(
                            data: '₹${order.deliveryEarnings ?? 0}',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                          const SizedBox(width: 8),
                          const CustomText(
                            data: '•',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.coolGrayColor,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            data: order.date ?? '',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const DottedLine(
                        direction: Axis.horizontal,
                        dashLength: 4,
                        dashGapLength: 3,
                        lineThickness: 1.0,
                        dashColor: AppColors.slateGrayColor,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(height: 4),
                              const DottedLine(
                                direction: Axis.vertical,
                                lineLength: 40,
                                dashLength: 3,
                                dashGapLength: 3,
                                lineThickness: 1.5,
                                dashColor: AppColors.coolGrayColor,
                              ),
                              const SizedBox(height: 4),
                              const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.crimsonRedColor,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      data: "Pickup",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.whiteColor,
                                    ),
                                    const SizedBox(height: 3),
                                    CustomText(
                                      data: pickupDescText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.coolGrayColor,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      data: "Drop",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.whiteColor,
                                    ),
                                    const SizedBox(height: 3),
                                    CustomText(
                                      data: dropDescText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.coolGrayColor,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const DottedLine(
                        direction: Axis.horizontal,
                        dashLength: 4,
                        dashGapLength: 3,
                        lineThickness: 1.0,
                        dashColor: AppColors.slateGrayColor,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AppCachedNetworkImage(
                              imageUrl:
                                  (order.productImages != null &&
                                      order.productImages!.isNotEmpty)
                                  ? order.productImages![0]
                                  : 'https://images.pexels.com/photos/9001223/pexels-photo-9001223.jpeg',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  data: displayProductName,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                ),
                                if (extraItemsText.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  CustomText(
                                    data: extraItemsText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.coolGrayBlueColor,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
