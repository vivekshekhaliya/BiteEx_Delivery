import 'package:bite_ex_delivery/view/profile_view/components/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';
import '../../view_model/auth_view_model.dart';
import 'components/menu_item.dart';
import 'components/user_profile_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkGunmetalColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const CustomText(
          data: "Logout",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        content: const CustomText(
          data: "Are you sure you want to log out?",
          fontSize: 14,
          color: AppColors.lightBlueGrayColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const CustomText(
              data: "Cancel",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.lightBlueGrayColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              final authViewModel = Provider.of<AuthViewModel>(
                context,
                listen: false,
              );
              authViewModel.logout(context);
            },
            child: const CustomText(
              data: "Logout",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
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
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ProfileHeader(),
        backgroundColor: AppColors.secondaryColor,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          UserProfileImage(),
          SizedBox(height: 30),

          CustomText(
            data: "About",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.lightBlueGrayColor,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          SizedBox(height: 12),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.darkGunmetalColor,
            ),
            child: Column(
              children: [
                MenuItem(
                  assetName: 'assets/svg_icon/faq_icon.svg',
                  title: "FAQs",
                  onTap: () {},
                ),
                _divider(),
                MenuItem(
                  assetName: 'assets/svg_icon/terms_condition_icon.svg',
                  title: "Terms & Conditions",
                  onTap: () {},
                ),
                _divider(),
                MenuItem(
                  assetName: 'assets/svg_icon/privacy_policy_icon.svg',
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                _divider(),
                MenuItem(
                  assetName: 'assets/svg_icon/info_circle_icon.svg',
                  title: "Help & Support",
                  onTap: () {},
                ),
                // _divider(),
                // MenuItem(
                //   assetName: 'assets/svg_icon/delete_icon.svg',
                //   title: "Delete Account",
                //   onTap: () {},
                // ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.darkGunmetalColor,
            ),
            child: MenuItem(
              assetName: 'assets/svg_icon/logout_icon.svg',
              title: "Logout",
              onTap: () => _showLogoutDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Divider(color: AppColors.jetGrayColor, thickness: 1, height: 1),
    );
  }
}
