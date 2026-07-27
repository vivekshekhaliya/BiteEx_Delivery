import 'package:bite_ex_delivery/res/components/app_cached_network_image.dart';
import 'package:bite_ex_delivery/res/constants/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/order_details_model.dart';
import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class UserContact extends StatelessWidget {
  final Customer? customer;
  const UserContact({super.key, this.customer});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCachedNetworkImage(
          imageUrl: customer?.image ?? 'https://testingbot.com/free-online-tools/random-avatar/200',
          height: 48,
          width: 48,
          borderRadius: BorderRadius.circular(100),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              data: customer?.name ?? 'Jack white',
              fontSize: 16,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 6),
            CustomText(
              data: customer?.mobile ?? '9999-999-99',
              fontSize: 13,
              color: AppColors.lightBlueGrayColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () async {
            final mobile = customer?.mobile;
            if (mobile != null && mobile.trim().isNotEmpty) {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: mobile.trim(),
              );
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              } else {
                if (context.mounted) {
                  ToastMessage.cherryMessage(
                    context,
                    "Could not launch call redirect",
                    ToastType.error,
                  );
                }
              }
            } else {
              ToastMessage.cherryMessage(
                context,
                "Phone number is empty or invalid",
                ToastType.error,
              );
            }
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.jetGrayColor),
              color: AppColors.darkGunmetalColor,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg_icon/call_icon.svg',
                height: 24,
                width: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
