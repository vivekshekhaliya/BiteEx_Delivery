import 'package:bite_ex_delivery/res/components/custom_text.dart';
import 'package:bite_ex_delivery/view/home_view/components/header_view.dart';
import 'package:bite_ex_delivery/view/home_view/components/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/constants/app_colors.dart';
import 'components/info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(),

          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 16),
              InfoCard(label: 'Total Earnings', count: '₹7554.00'),
              SizedBox(width: 16),
              InfoCard(label: 'Total Order Delivered', count: '1000'),
              SizedBox(width: 16),
            ],
          ),

          CustomText(
            data: 'Current Delivery',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
            padding: EdgeInsets.only(left: 16, top: 16),
          ),

          RequestCard(),
        ],
      ),
    );
  }
}
