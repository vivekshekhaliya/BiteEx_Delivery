import 'package:bite_ex_delivery/res/components/custom_app_button.dart';
import 'package:bite_ex_delivery/res/components/custom_text.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/complete_verification.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/food_product.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/order_number.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/pickup_drop_location.dart';
import 'package:bite_ex_delivery/view/order_details_view/components/user_contact.dart';
import 'package:flutter/material.dart';
import '../../res/components/custom_app_bar.dart';
import '../../res/constants/app_colors.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: CustomAppBar(title: 'Order detail'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderNumber(),

              UserContact(),

              Divider(color: AppColors.jetGrayColor, height: 20, thickness: 1),

              PickupDropLocation(),

              CompleteVerification(),

              FoodProduct(),

              CustomText(
                data: 'Delivery Instructions',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.darkGunmetalColor,
                  border: Border.all(color: AppColors.jetGrayColor, width: 1),
                ),
                child: CustomText(
                  data: 'Leave at gate',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        decoration: BoxDecoration(
          color: AppColors.darkGunmetalColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(child: CustomAppButton(text: 'Start Delivery')),
      ),
    );
  }
}
