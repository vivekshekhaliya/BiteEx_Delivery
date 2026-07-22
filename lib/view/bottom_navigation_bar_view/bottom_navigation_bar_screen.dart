import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';
import '../../services/web_socket_manager.dart';
import '../../view_model/rider_view_model.dart';
import 'package:provider/provider.dart';
import '../delivery_view/delivery_screen.dart';
import '../home_view/home_screen.dart';
import '../profile_view/profile_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  // final NotificationService _notificationService = NotificationService();
  int _selectedIndex = 0;
  StreamSubscription? _socketSubscription;

  final List<Map<String, String>> _items = [
    {"icon": "assets/svg_icon/home_tab_bar_icon.svg", "label": "Home"},
    {"icon": "assets/svg_icon/delivery_tab_bar_icon.svg", "label": "Delivery"},
    {"icon": "assets/svg_icon/profile_tab_bar_icon.svg", "label": "Profile"},
  ];

  final List<Widget> _pages = const [
    HomeScreen(),
    DeliveryScreen(),
    ProfileScreen(),
  ];

  Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus();

    final status = await newVersion.getVersionStatus();

    if (status != null && status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: "Update Available",
        dialogText: "A new version of the app is available.",
        updateButtonText: "Update",
        dismissButtonText: "Later",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _listenToWebSocketEvents();
    // _notificationService.initialize();
    // _notificationService.onNotificationTap.stream.listen((data) {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkForUpdate(context);
    });
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    super.dispose();
  }

  /// Listen to WebSocket stream for delivery_orders_updated events
  void _listenToWebSocketEvents() {
    _socketSubscription = WebSocketManager().stream.listen((data) {
      if (data is Map) {
        if (data['type'] == 'delivery_orders_updated' || data['channel'] == 'delivery-orders') {
          if (mounted) {
            final riderVM = Provider.of<RiderViewModel>(context, listen: false);
            riderVM.getAvailableOrdersApi(context);
            riderVM.getRiderDashboardApi(context);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.whiteColor.withAlpha(10),
              offset: const Offset(0, -4), // top shadow
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final bool isSelected = _selectedIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: size.width / 6,
              padding: EdgeInsets.fromLTRB(0, 14, 0, padding.bottom),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: SvgPicture.asset(
                        _items[index]["icon"]!,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? AppColors.primaryColor
                              : AppColors.coolGrayColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.coolGrayColor,
                      ),
                      child: CustomText(
                        data: _items[index]["label"]!,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.coolGrayColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
