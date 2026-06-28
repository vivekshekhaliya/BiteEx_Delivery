import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../res/components/custom_text.dart';

class MenuItem extends StatefulWidget {
  final String title;
  final GestureTapCallback? onTap;
  final String assetName;
  const MenuItem({
    super.key,
    required this.title,
    this.onTap,
    required this.assetName,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 0, top: 15, bottom: 15),
        child: Row(
          children: [
            SvgPicture.asset(widget.assetName, height: 24, width: 24),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                data: widget.title,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: 0.6,
              ),
            ),
            SvgPicture.asset(
              'assets/svg_icon/arrow_right_arrow.svg',
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
