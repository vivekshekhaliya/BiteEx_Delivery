import 'package:bite_ex_delivery/res/components/app_cached_network_image.dart';
import 'package:bite_ex_delivery/res/components/custom_text.dart';
import 'package:bite_ex_delivery/res/constants/app_colors.dart';
import 'package:bite_ex_delivery/view/order_details_view/order_details_screen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:bite_ex_delivery/model/available_order_model.dart';
import 'package:bite_ex_delivery/view_model/rider_view_model.dart';
import 'package:bite_ex_delivery/view/map_view/map_screen.dart';

class RequestCard extends StatefulWidget {
  final AvailableOrder? order;

  const RequestCard({super.key, this.order});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGunmetalColor,
        borderRadius: BorderRadius.circular(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkGunmetalColor,
                border: Border.all(color: AppColors.jetGrayColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: AppColors.mintGreenColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg_icon/location_pin.svg',
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              data: "Pickup :",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                            CustomText(
                              data:
                                  widget.order?.pickupName ??
                                  "BiteEx Restaurant",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 14, bottom: 6, top: 6),
                    child: DottedLine(
                      direction: Axis.vertical,
                      lineLength: 30,
                      dashLength: 4,
                      dashGapLength: 3,
                      lineThickness: 2,
                      dashColor: AppColors.whiteColor,
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: AppColors.mintGreenColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg_icon/location_pin.svg',
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              data: "Drop :",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                            InkWell(
                              onTap: () {
                                final lat = widget.order?.latitude ?? 23.050473;
                                final lng =
                                    widget.order?.longitude ?? 72.533682;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      latitude: lat,
                                      longitude: lng,
                                      address:
                                          widget.order?.dropLocation ??
                                          "Ahmedabad University",
                                    ),
                                  ),
                                );
                              },
                              child: CustomText(
                                data:
                                    widget.order?.dropLocation ??
                                    "Ahmedabad University",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                height: 1,
                thickness: 0.6,
                color: AppColors.darkSlateGrayColor,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                CustomText(
                  data: widget.order != null
                      ? '₹${widget.order!.deliveryEarnings}'
                      : '₹25.00',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightBlueGrayColor,
                  padding: EdgeInsets.only(left: 12),
                ),
                SizedBox(width: 10),
                CustomText(
                  data: '•',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkSlateGrayColor,
                ),
                SizedBox(width: 10),
                CustomText(
                  data: widget.order?.date ?? '07 Feb, 9:10 PM',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightBlueGrayColor,
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.orangeColor.withAlpha(40),
                  ),
                  child: CustomText(
                    data: widget.order?.status ?? 'In Process',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.orangeColor,
                  ),
                ),
              ],
            ),
            CustomText(
              data: widget.order?.orderNumber ?? '#ORDER-17',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.lightBlueGrayColor,
              padding: EdgeInsets.only(left: 12, top: 4),
            ),
            if (widget.order?.productImages != null &&
                widget.order!.productImages!.isNotEmpty)
              SizedBox(
                height: 70,
                child: ListView.builder(
                  itemCount: widget.order!.productImages!.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 16),
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AppCachedNetworkImage(
                        imageUrl: widget.order!.productImages![index],
                        height: 44,
                        width: 44,
                        borderRadius: BorderRadius.circular(4),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              )
            else
              SizedBox(
                height: 70,
                child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 16),
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AppCachedNetworkImage(
                        imageUrl:
                            'https://images.pexels.com/photos/9001223/pexels-photo-9001223.jpeg',
                        height: 44,
                        width: 44,
                        borderRadius: BorderRadius.circular(4),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            if (widget.order?.status == 'In Process' ||
                widget.order?.status?.toLowerCase() == 'preparing' ||
                widget.order?.status?.toLowerCase() == 'in_process' ||
                widget.order?.status?.toLowerCase() == 'pending') ...[
              Divider(
                height: 0,
                thickness: 0.6,
                color: AppColors.darkSlateGrayColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed:
                        (widget.order == null ||
                            Provider.of<RiderViewModel>(context).actionLoading)
                        ? null
                        : () {
                            Provider.of<RiderViewModel>(
                              context,
                              listen: false,
                            ).rejectOrderApi(context, widget.order!.orderId!);
                          },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.darkGunmetalColor,
                      disabledBackgroundColor: AppColors.darkGunmetalColor,
                      fixedSize: Size(size.width / 2.2, 46),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: CustomText(
                      data: 'Cancel',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  Container(
                    height: 46,
                    width: 0.6,
                    color: AppColors.darkSlateGrayColor,
                  ),
                  ElevatedButton(
                    onPressed:
                        (widget.order == null ||
                            Provider.of<RiderViewModel>(context).actionLoading)
                        ? null
                        : () {
                            Provider.of<RiderViewModel>(
                              context,
                              listen: false,
                            ).acceptOrderApi(context, widget.order!.orderId!);
                          },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.darkGunmetalColor,
                      disabledBackgroundColor: AppColors.darkGunmetalColor,
                      fixedSize: Size(size.width / 2.2, 46),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Provider.of<RiderViewModel>(context).actionLoading
                        ? Center(
                            child:
                                LoadingAnimationWidget.horizontalRotatingDots(
                                  color: AppColors.primaryColor,
                                  size: 30,
                                ),
                          )
                        : CustomText(
                            data: 'Accept',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
