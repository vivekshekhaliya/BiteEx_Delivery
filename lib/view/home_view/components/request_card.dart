import 'package:bite_ex_delivery/res/components/app_cached_network_image.dart';
import 'package:bite_ex_delivery/res/components/custom_app_button.dart';
import 'package:bite_ex_delivery/res/components/custom_text.dart';
import 'package:bite_ex_delivery/res/constants/app_colors.dart';
import 'package:bite_ex_delivery/view/order_details_view/order_details_screen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:bite_ex_delivery/model/available_order_model.dart';
import 'package:bite_ex_delivery/view_model/rider_view_model.dart';

class RequestCard extends StatefulWidget {
  final AvailableOrder? order;

  const RequestCard({super.key, this.order});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.darkGunmetalColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slateGrayColor.withAlpha(80)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailsScreen(orderId: widget.order?.orderId ?? 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // New Request Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF132F20),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(0xFF1DA15B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        CustomText(
                          data: "New Request",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1DA15B),
                        ),
                      ],
                    ),
                  ),
                  // Preparing Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2415),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_filled_rounded,
                          color: AppColors.orangeColor,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          data: widget.order?.status ?? "",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.orangeColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Divider
              const SizedBox(height: 18),
              const DottedLine(
                direction: Axis.horizontal,
                dashLength: 4,
                dashGapLength: 3,
                lineThickness: 1.0,
                dashColor: AppColors.slateGrayColor,
              ),
              const SizedBox(height: 18),

              // Timeline Address Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const DottedLine(
                        direction: Axis.vertical,
                        lineLength: 30,
                        dashLength: 3,
                        dashGapLength: 3,
                        lineThickness: 1.5,
                        dashColor: AppColors.coolGrayColor,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(height: 3),
                            CustomText(
                              data: widget.order?.pickupName ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              data: "Drop",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(height: 3),
                            CustomText(
                              data: widget.order?.dropLocation ?? "",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Divider
              const DottedLine(
                direction: Axis.horizontal,
                dashLength: 4,
                dashGapLength: 3,
                lineThickness: 1.0,
                dashColor: AppColors.slateGrayColor,
              ),
              const SizedBox(height: 16),

              // Split Info Row (Earnings, Date, Time)
              Row(
                children: [
                  // Earnings Column
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CustomText(
                              data: "₹",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                data: widget.order != null
                                    ? '₹${widget.order!.deliveryEarnings}'
                                    : '',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor,
                              ),
                              const SizedBox(height: 2),
                              const CustomText(
                                data: "Earnings",
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.coolGrayColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: AppColors.darkSlateGrayColor,
                  ),
                  // Date Column
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.primaryColor,
                              size: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                data:
                                    widget.order?.date?.split(',')[0].trim() ??
                                    "",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor,
                              ),
                              const SizedBox(height: 2),
                              const CustomText(
                                data: "Date",
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.coolGrayColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: AppColors.darkSlateGrayColor,
                  ),
                  // Time Column
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.access_time_rounded,
                              color: AppColors.primaryColor,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                data:
                                    (widget.order?.date != null &&
                                        widget.order!.date!.contains(','))
                                    ? widget.order!.date!.split(',')[1].trim()
                                    : "",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor,
                              ),
                              const SizedBox(height: 2),
                              const CustomText(
                                data: "Time",
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.coolGrayColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Nested order details box
              const DottedLine(
                direction: Axis.horizontal,
                dashLength: 4,
                dashGapLength: 3,
                lineThickness: 1.0,
                dashColor: AppColors.slateGrayColor,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AppCachedNetworkImage(
                      imageUrl:
                          (widget.order?.productImages != null &&
                              widget.order!.productImages!.isNotEmpty)
                          ? widget.order!.productImages![0]
                          : 'https://images.pexels.com/photos/9001223/pexels-photo-9001223.jpeg',
                      height: 52,
                      width: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          data:
                              widget.order?.orderNumber?.startsWith('#') == true
                              ? (widget.order?.orderNumber ?? '')
                              : '#${widget.order?.orderNumber ?? ''}',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          data:
                              '${widget.order?.itemsCount ?? 1} Item  •  ${widget.order?.category ?? ''}',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.coolGrayColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Accept / Cancel action buttons row
              const DottedLine(
                direction: Axis.horizontal,
                dashLength: 4,
                dashGapLength: 3,
                lineThickness: 1.0,
                dashColor: AppColors.slateGrayColor,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomAppButton(
                      text: 'Cancel',
                      height: 44,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: AppColors.slateGrayColor,
                      onPressed:
                          (widget.order == null ||
                              Provider.of<RiderViewModel>(
                                context,
                              ).actionLoading)
                          ? null
                          : () {
                              Provider.of<RiderViewModel>(
                                context,
                                listen: false,
                              ).rejectOrderApi(context, widget.order!.orderId!);
                            },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomAppButton(
                      text: 'Accept',
                      height: 44,
                      borderRadius: BorderRadius.circular(10),
                      isLoading: Provider.of<RiderViewModel>(
                        context,
                      ).actionLoading,
                      onPressed:
                          (widget.order == null ||
                              Provider.of<RiderViewModel>(
                                context,
                              ).actionLoading)
                          ? null
                          : () {
                              Provider.of<RiderViewModel>(
                                context,
                                listen: false,
                              ).acceptOrderApi(context, widget.order!.orderId!);
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
