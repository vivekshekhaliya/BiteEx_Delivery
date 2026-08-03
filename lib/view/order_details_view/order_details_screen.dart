import 'package:bite_ex_delivery/res/components/custom_app_button.dart';
import 'package:bite_ex_delivery/res/components/custom_text.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/complete_verification.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/food_product.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/order_number.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/pickup_drop_location.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/user_contact.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/qr_code_sheet.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../res/components/custom_app_bar.dart';
import '../../res/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../view_model/rider_view_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RiderViewModel>(
        context,
        listen: false,
      ).getOrderDetailsApi(context, widget.orderId);
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  bool _isOnTheWay(String? status) {
    if (status == null) return false;
    final lower = status.toLowerCase();
    return lower == 'on the way' || lower == 'on_the_way';
  }

  bool _isCompleted(String? status) {
    if (status == null) return false;
    final lower = status.toLowerCase();
    return lower == 'completed' || lower == 'delivered';
  }

  bool _isPreparingOrPending(String? status) {
    if (status == null) return false;
    final lower = status.toLowerCase();
    return lower == 'preparing' ||
        lower == 'in process' ||
        lower == 'in_process' ||
        lower == 'pending';
  }

  @override
  Widget build(BuildContext context) {
    final riderVM = Provider.of<RiderViewModel>(context);
    final order = riderVM.orderDetailsData?.data;
    final isOnTheWay = _isOnTheWay(order?.status);
    final isCompleted = _isCompleted(order?.status);
    final isPreparing = _isPreparingOrPending(order?.status);
    final size = MediaQuery.of(context).size;

    final method = order?.paymentMethod?.toUpperCase();
    final showCollectUpi =
        (method == 'COD' || method == 'CASH') &&
        (order?.paymentStatus == null ||
            order?.paymentStatus?.trim().isEmpty == true ||
            order?.paymentStatus?.toLowerCase() == 'pending' ||
            order?.paymentStatus?.toLowerCase() == 'unpaid');

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: CustomAppBar(title: 'Order detail'),
      body: riderVM.orderDetailsLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : order == null
          ? const Center(
              child: Text(
                'No order details found',
                style: TextStyle(color: Colors.white),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderNumber(order: order),

                    UserContact(customer: order.customer),

                    const Divider(
                      color: AppColors.jetGrayColor,
                      height: 20,
                      thickness: 1,
                    ),

                    PickupDropLocation(pickup: order.pickup, drop: order.drop),

                    if (isOnTheWay)
                      CompleteVerification(controller: _otpController),

                    FoodProduct(
                      items: order.items,
                      amount: order.totalAmount,
                      earnings: order.deliveryEarnings,
                      paymentMethod: order.paymentMethod,
                    ),

                    if (isOnTheWay && showCollectUpi) ...[
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => QrCodeSheet(
                              orderId: order.orderId!,
                              amount:
                                  double.tryParse(
                                        order.totalAmount?.toString() ?? '0',
                                      ) ??
                                      0.0,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Ink(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.primaryColor.withOpacity(0.05),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.qr_code_2,
                                  color: AppColors.primaryColor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      data: 'Collect UPI Payment',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor,
                                    ),
                                    const SizedBox(height: 6),
                                    CustomText(
                                      data:
                                          'Collect ₹${double.tryParse(order.totalAmount?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'} digitally. Click to show QR.',
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.lightCoolGrayColor,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.coolGrayColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    if (order.deliveryInstructions != null &&
                        order.deliveryInstructions!.isNotEmpty) ...[
                      const CustomText(
                        data: 'Delivery Instructions',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.whiteColor,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.darkGunmetalColor,
                          border: Border.all(
                            color: AppColors.jetGrayColor,
                            width: 1,
                          ),
                        ),
                        child: CustomText(
                          data: order.deliveryInstructions!,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
      bottomNavigationBar:
          order == null || riderVM.orderDetailsLoading || isCompleted
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              decoration: const BoxDecoration(
                color: AppColors.darkGunmetalColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: isPreparing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: riderVM.actionLoading
                                ? null
                                : () async {
                                    if (order.orderId != null) {
                                      final res = await riderVM.rejectOrderApi(
                                        context,
                                        order.orderId!,
                                      );
                                      if (res && context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.darkGunmetalColor,
                              disabledBackgroundColor:
                                  AppColors.darkGunmetalColor,
                              side: const BorderSide(
                                color: AppColors.jetGrayColor,
                              ),
                              fixedSize: Size(size.width / 2.3, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const CustomText(
                              data: 'Cancel',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: riderVM.actionLoading
                                ? null
                                : () async {
                                    if (order.orderId != null) {
                                      final res = await riderVM.acceptOrderApi(
                                        context,
                                        order.orderId!,
                                      );
                                      if (res && context.mounted) {
                                        riderVM.getOrderDetailsApi(
                                          context,
                                          order.orderId!,
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primaryColor,
                              disabledBackgroundColor: AppColors.primaryColor,
                              fixedSize: Size(size.width / 2.3, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: riderVM.actionLoading
                                ? Center(
                                    child:
                                        LoadingAnimationWidget.horizontalRotatingDots(
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                  )
                                : const CustomText(
                                    data: 'Accept',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      )
                    : (isOnTheWay && showCollectUpi)
                    ? Opacity(
                        opacity: riderVM.isQrActive ? 0.5 : 1.0,
                        child: CustomAppButton(
                          text: 'Complete Delivery',
                          isLoading: riderVM.actionLoading,
                          onPressed: riderVM.isQrActive
                              ? null
                              : () async {
                                  if (order.orderId != null) {
                                    final otp =
                                        _otpController.text
                                            .trim()
                                            .isNotEmpty
                                        ? _otpController.text.trim()
                                        : '1234';
                                    final success = await riderVM
                                        .completeDeliveryApi(
                                          context,
                                          order.orderId!,
                                          otp: otp,
                                        );
                                    if (success && context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                        ),
                      )
                    : CustomAppButton(
                        text: isOnTheWay
                            ? 'Complete Delivery'
                            : 'Start Delivery',
                        isLoading: riderVM.actionLoading,
                        onPressed: () async {
                          if (order.orderId != null) {
                            if (isOnTheWay) {
                              final otp = _otpController.text.trim().isNotEmpty
                                  ? _otpController.text.trim()
                                  : '1234';
                              final success = await riderVM.completeDeliveryApi(
                                context,
                                order.orderId!,
                                otp: otp,
                              );
                              if (success && context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              await riderVM.startDeliveryApi(
                                context,
                                order.orderId!,
                              );
                              if (context.mounted) {
                                riderVM.getOrderDetailsApi(
                                  context,
                                  order.orderId!,
                                );
                              }
                            }
                          }
                        },
                      ),
              ),
            ),
    );
  }
}
