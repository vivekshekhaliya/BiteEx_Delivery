import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/order_details_model.dart';
import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';
import '../../../view/map_view/map_screen.dart';

class PickupDropLocation extends StatelessWidget {
  final Pickup? pickup;
  final Drop? drop;
  const PickupDropLocation({super.key, this.pickup, this.drop});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      data: (pickup?.location != null && pickup!.location!.isNotEmpty)
                          ? "${pickup?.name ?? 'Pickup'} - ${pickup!.location}"
                          : (pickup?.name ?? "BiteEx Outlet"),
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
                        double? lat;
                        double? lng;
                        if (drop?.latitude != null) {
                          lat = double.tryParse(drop!.latitude.toString());
                        }
                        if (drop?.longitude != null) {
                          lng = double.tryParse(drop!.longitude.toString());
                        }
                        final addressText = drop?.address;
                        if ((lat == null || lng == null) && addressText != null) {
                          final parts = addressText.split(',');
                          if (parts.length == 2) {
                            final parsedLat = double.tryParse(parts[0].trim());
                            final parsedLng = double.tryParse(parts[1].trim());
                            if (parsedLat != null && parsedLng != null) {
                              lat = parsedLat;
                              lng = parsedLng;
                            }
                          }
                        }
                        lat ??= 23.050473;
                        lng ??= 72.533682;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(
                              latitude: lat!,
                              longitude: lng!,
                              address: addressText ?? "Ahmedabad University",
                            ),
                          ),
                        );
                      },
                      child: CustomText(
                        data: drop?.address ?? "Ahmedabad University",
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
    );
  }
}
