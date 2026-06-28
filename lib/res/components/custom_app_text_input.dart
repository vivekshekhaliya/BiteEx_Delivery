import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class CustomAppTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? prefixText;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  const CustomAppTextInput({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.fillColor,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
    this.onChanged,
    this.prefixText,
    this.maxLength,
  });

  @override
  State<CustomAppTextInput> createState() => _CustomAppTextInputState();
}

class _CustomAppTextInputState extends State<CustomAppTextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText ?? false,
      textInputAction: TextInputAction.done,
      style: GoogleFonts.inter(
        color: AppColors.whiteColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      keyboardAppearance: Brightness.dark,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus(); // closes keyboard
        // or call your submit function here
      },
      decoration: InputDecoration(
        hintText: widget.hintText ?? "",
        hintStyle: GoogleFonts.inter(
          color: AppColors.coolGrayColor,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),

        counterText: "",

        prefixText: (widget.controller?.text.isNotEmpty ?? false)
            ? widget.prefixText
            : null,
        prefixStyle: GoogleFonts.inter(
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),

        errorStyle: GoogleFonts.inter(
          color: AppColors.crimsonRedColor,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),

        filled: true,
        fillColor: widget.fillColor ?? AppColors.secondaryColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.darkSlateGrayColor, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.darkSlateGrayColor,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.darkSlateGrayColor,
            width: 1,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.darkSlateGrayColor,
            width: 1,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
