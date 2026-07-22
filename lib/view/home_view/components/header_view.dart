import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../res/components/custom_text.dart';
import '../../../../res/constants/app_colors.dart';
import '../../../../view_model/rider_view_model.dart';

class HeaderView extends StatefulWidget {
  const HeaderView({super.key});

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).padding;
    final riderVM = Provider.of<RiderViewModel>(context);
    final riderName = riderVM.dashboardData?.data?.riderName ?? "Rider";
    
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: Platform.isIOS ? insets.top : insets.top + 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.transparentColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.transparentColor),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset('assets/icons/new_app_icon.png'),
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                data: "Good Evening,",
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              CustomText(
                data: "$riderName 👋",
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),

          const Spacer(),

          // Rider Online / Offline ON-OFF Toggle Switch
          GestureDetector(
            onTap: () async {
              final newStatus = !riderVM.isOnline;
              await riderVM.updateRiderStatusApi(context, newStatus);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: riderVM.isOnline
                    ? AppColors.primaryColor.withAlpha(40)
                    : AppColors.crimsonRedColor.withAlpha(40),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: riderVM.isOnline
                      ? AppColors.primaryColor
                      : AppColors.crimsonRedColor,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: riderVM.isOnline
                          ? AppColors.primaryColor
                          : AppColors.crimsonRedColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    data: riderVM.isOnline ? 'ON' : 'OFF',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: riderVM.isOnline
                        ? AppColors.primaryColor
                        : AppColors.crimsonRedColor,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 24,
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: SvgPicture.asset('assets/svg_icon/notification_icon.svg'),
          ),
        ],
      ),
    );
  }
}
