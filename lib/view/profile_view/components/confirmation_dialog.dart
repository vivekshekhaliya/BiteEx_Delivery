import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/components/custom_app_button.dart';
import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class ConfirmationDialog extends StatefulWidget {
  final String label;
  final String description;
  final String assetName;
  final VoidCallback onCallBack;
  final bool isLoading;
  const ConfirmationDialog({
    super.key,
    required this.label,
    required this.description,
    required this.assetName,
    required this.onCallBack,
    this.isLoading = false,
  });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.jetGrayColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.darkGunmetalColor,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      widget.assetName,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.crimsonRedColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CustomText(
                  data: widget.label,
                  fontSize: 18,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
                Spacer(),
                IconButton(
                  onPressed: widget.isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  constraints: BoxConstraints(),
                  splashColor: Colors.red,
                  icon: Icon(Icons.close, color: AppColors.coolGrayBlueColor),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: CustomText(
                data: widget.description,
                fontSize: 16,
                color: AppColors.lightCoolGrayColor,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            CustomAppButton(
              text: widget.label,
              isLoading: widget.isLoading,
              onPressed: widget.onCallBack,
            ),
          ],
        ),
      ),
    );
  }
}
