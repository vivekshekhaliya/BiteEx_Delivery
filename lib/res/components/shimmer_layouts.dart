import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../constants/app_colors.dart';

class RequestCardShimmer extends StatelessWidget {
  const RequestCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGunmetalColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slateGrayColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top badges row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 95,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Timeline
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.darkSlateGrayColor.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 2,
                    height: 30,
                    color: AppColors.darkSlateGrayColor.withAlpha(120),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.darkSlateGrayColor.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 50,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 200,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Divider
          Container(
            height: 1,
            color: AppColors.darkSlateGrayColor.withAlpha(120),
          ),
          const SizedBox(height: 16),

          // Info Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.darkSlateGrayColor.withAlpha(120),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.darkSlateGrayColor.withAlpha(120),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.darkSlateGrayColor.withAlpha(120),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            color: AppColors.darkSlateGrayColor.withAlpha(120),
          ),
          const SizedBox(height: 16),

          // Food Item Container
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Buttons Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.darkSlateGrayColor.withAlpha(120),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.darkSlateGrayColor.withAlpha(120),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryCardShimmer extends StatelessWidget {
  const HistoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGunmetalColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 50,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: AppColors.darkSlateGrayColor.withAlpha(120),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.darkSlateGrayColor.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.darkSlateGrayColor.withAlpha(120),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.darkSlateGrayColor.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 50,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      width: 180,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: AppColors.darkSlateGrayColor.withAlpha(120),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.darkSlateGrayColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 70,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.darkSlateGrayColor.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
