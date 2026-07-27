import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../res/components/custom_app_bar.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? expandedIndex;
  late List<ExpansibleController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(faqList.length, (_) => ExpansibleController());
  }

  final List<Map<String, String>> faqList = [
    {
      "question": "1. What is Bite EX / BiteExchange?",
      "answer": "A platform with real-time dynamic pricing.",
    },
    {
      "question": "2. Why do prices change?",
      "answer": "Prices change based on demand.",
    },
    {
      "question": "3. What do colors mean?",
      "answer":
          "Green = decrease | Red = increase | White = neutral | Grey = Not Available",
    },
    {
      "question": "4. What is dynamic pricing?",
      "answer": "Prices change automatically in real time.",
    },
    {
      "question": "5. Price fluctuation ?",
      "answer":
          "Price Below ₹100 → +2 per order | Price ₹100and above → +₹5 per order\nPrice Below ₹100 → -₹2 no order placed in 30 min | Price ₹100 and above → -₹5 no order placed in 30 min",
    },
    {
      "question": "6. Will price sky rocket any time?",
      "answer":
          "NO they have a safe range. Price Below ₹100 → ±₹10 | Price ₹100 and above → ±₹20",
    },
    {
      "question": "7. Is price final after it is added in the cart?",
      "answer": "No. It will be final only after payment.",
    },
    {
      "question": "8. Can I lock price before paying?",
      "answer":
          "Yes. The price of the item will have a cart timer, when they are in order cart they will be locked if you run out of cart timer then prices will update",
    },
    {
      "question": "9. What is cart timer?",
      "answer": "Time limit to complete your order.",
    },
    {
      "question": "10. If cart expires?",
      "answer": "Cart resets and prices change.",
    },
    {
      "question": "11. Can I cancel order?",
      "answer": "No. Orders can’t be cancelled or modified.",
    },
    {
      "question": "12. When is order confirmed?",
      "answer": "Orders are only confirmed after the full payment.",
    },
    {
      "question": "13. Are items always available?",
      "answer": "No. All items have there own time of availability.",
    },
    {
      "question": "14. What if system has some issue?",
      "answer": "Platform will use fixed/base pricing.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: CustomAppBar(title: 'FAQs'),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12, right: 16, left: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkSlateGrayColor),
            ),
            child: ExpansionTile(
              controller: controllers[index],
              minTileHeight: 54,
              showTrailingIcon: false,
              initiallyExpanded: expandedIndex == index,
              onExpansionChanged: (value) {
                if (value) {
                  for (int i = 0; i < controllers.length; i++) {
                    if (i != index) {
                      controllers[i].collapse();
                    }
                  }
                }
                setState(() {
                  expandedIndex = value ? index : null;
                });
              },
              tilePadding: EdgeInsets.all(0),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.transparentColor),
              ),
              collapsedShape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.transparentColor),
              ),
              splashColor: AppColors.transparentColor,
              title: Row(
                children: [
                  SizedBox(width: 16),
                  SizedBox(
                    width: size.width / 1.4,
                    child: CustomText(
                      data: faqList[index]["question"]!,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Spacer(),
                  AnimatedRotation(
                    turns: expandedIndex == index ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: SvgPicture.asset(
                      'assets/svg_icon/arrow_up_icon.svg',
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Divider(
                  height: 10,
                  thickness: 1,
                  color: AppColors.darkSlateGrayColor,
                ),
                SizedBox(height: 10),
                CustomText(
                  data: faqList[index]["answer"]!,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
