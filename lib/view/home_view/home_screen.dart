import 'package:bite_ex_delivery/res/components/custom_text.dart';
import 'package:bite_ex_delivery/res/components/not_found.dart';
import 'package:bite_ex_delivery/view/home_view/components/header_view.dart';
import 'package:bite_ex_delivery/view/home_view/components/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../res/constants/app_colors.dart';
import '../../view_model/rider_view_model.dart';
import 'components/info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final riderVM = Provider.of<RiderViewModel>(context, listen: false);
      riderVM.getRiderDashboardApi(context);
      riderVM.getAvailableOrdersApi(context);
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
    final isSalaried = riderVM.dashboardData?.data?.isSalaried ?? false;
    final earnings = riderVM.dashboardData?.data?.totalEarnings ?? 0;
    final deliveredOrders =
        riderVM.dashboardData?.data?.totalDeliveredOrders ?? 0;
    final currentDelivery = riderVM.dashboardData?.data?.currentDelivery;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: riderVM.dashboardLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderView(),

                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(width: 16),
                      if (!isSalaried) ...[
                        InfoCard(label: 'Total Earnings', count: '₹$earnings'),
                        SizedBox(width: 16),
                      ],
                      InfoCard(
                        label: 'Total Order Delivered',
                        count: '$deliveredOrders',
                      ),
                      SizedBox(width: 16),
                    ],
                  ),

                  if (currentDelivery != null) ...[
                    const CustomText(
                      data: 'Current Delivery',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                      padding: EdgeInsets.only(left: 16, top: 16),
                    ),
                    RequestCard(order: currentDelivery),
                  ],

                  if (riderVM.availableOrdersData?.data != null &&
                      riderVM.availableOrdersData!.data!.isNotEmpty) ...[
                    const CustomText(
                      data: 'Available Orders',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                      padding: EdgeInsets.only(left: 16, top: 16),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: riderVM.availableOrdersData!.data!.length,
                      itemBuilder: (context, index) {
                        final order = riderVM.availableOrdersData!.data![index];
                        return RequestCard(order: order);
                      },
                    ),
                  ],

                  if (currentDelivery == null &&
                      (riderVM.availableOrdersData?.data == null ||
                          riderVM.availableOrdersData!.data!.isEmpty)) ...[
                    NotFound(title: 'No active or available orders'),
                  ],
                ],
              ),
            ),
    );
  }
}
