import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';
import 'package:provider/provider.dart';
import '../../../../res/components/custom_text.dart';
import '../../../../res/constants/app_colors.dart';
import '../../../../view_model/rider_view_model.dart';

class HeaderView extends StatefulWidget {
  final bool isOnline;
  const HeaderView({super.key, required this.isOnline});

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    isOnline = widget.isOnline;
  }

  @override
  void didUpdateWidget(covariant HeaderView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isOnline != widget.isOnline) {
      isOnline = widget.isOnline;
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    if (hour >= 17 && hour < 21) return "Good Evening";
    return "Good Evening";
  }

  Future<bool> _toggle() async {
    final riderVM = Provider.of<RiderViewModel>(context, listen: false);

    final newStatus = !isOnline;

    try {
      await riderVM.updateRiderStatusApi(context, newStatus);
      return newStatus;
    } catch (e) {
      debugPrint('Status update failed: $e');
      return isOnline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riderVM = Provider.of<RiderViewModel>(context);
    final riderName = riderVM.dashboardData?.data?.riderName ?? "Rider";

    return Container(
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
                data: "$greeting,",
                color: AppColors.whiteColor,
                fontSize: 14,
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: isOnline
                  ? AppColors.primaryColor.withAlpha(40)
                  : AppColors.crimsonRedColor.withAlpha(40),
              border: Border.all(
                color: isOnline
                    ? AppColors.primaryColor
                    : AppColors.crimsonRedColor,
                width: 0.4,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 4),
                SizedBox(
                  width: 54,
                  child: CustomText(
                    data: isOnline ? 'Online' : 'Offline',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isOnline
                        ? AppColors.primaryColor
                        : AppColors.crimsonRedColor,
                  ),
                ),
                const SizedBox(width: 8),

                SizedBox(
                  width: 38,
                  child: LoadSwitch.managed(
                    value: isOnline,
                    onToggle: _toggle,
                    onChanged: (nextValue) {
                      setState(() {
                        isOnline = nextValue;
                      });

                      debugPrint(
                        'Rider status: ${nextValue ? "Online" : "Offline"}',
                      );
                    },
                    width: 36,
                    height: 20,
                    style: SpinStyle.fadingCircle,
                    curveIn: Curves.easeInBack,
                    curveOut: Curves.easeOutBack,
                    switchAnimationDuration: const Duration(milliseconds: 500),
                    spinnerAnimationDuration: const Duration(milliseconds: 900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
