import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/components/app_cached_network_image.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';
import 'components/delivery_header.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: DeliveryHeader(),
        backgroundColor: AppColors.secondaryColor,
      ),

      body: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
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
                    Column(
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
                          data: "BiteEx Restaurant",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          data: "Drop :",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor,
                        ),
                        CustomText(
                          data: "Ahmedabad University",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 0.6,
                  color: AppColors.darkSlateGrayColor,
                ),
                Row(
                  children: [
                    CustomText(
                      data: '₹25.00',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightBlueGrayColor,
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
                      data: '07 Feb, 9:10 PM',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightBlueGrayColor,
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.orangeColor.withAlpha(40),
                      ),
                      child: CustomText(
                        data: 'In Process',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orangeColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                CustomText(
                  data: '#ORDER-17',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightBlueGrayColor,
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
