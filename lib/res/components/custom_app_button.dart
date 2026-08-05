import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/app_colors.dart';
import 'custom_text.dart';

class CustomAppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;
  const CustomAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.backgroundColor,
    this.fontSize,
    this.height,
    this.borderRadius,
  });

  @override
  State<CustomAppButton> createState() => _CustomAppButtonState();
}

class _CustomAppButtonState extends State<CustomAppButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: widget.isLoading ?? false ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: widget.backgroundColor ?? AppColors.primaryColor,
        disabledBackgroundColor:
            widget.backgroundColor ?? AppColors.primaryColor,
        fixedSize: Size(widget.width ?? size.width, widget.height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
        ),
      ),
      child: widget.isLoading ?? true
          ? Center(
              child: LoadingAnimationWidget.horizontalRotatingDots(
                color: AppColors.whiteColor,
                size: 40,
              ),
            )
          : CustomText(
              data: widget.text,
              fontSize: widget.fontSize ?? 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
    );
  }
}
