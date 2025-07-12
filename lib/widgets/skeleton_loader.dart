import 'package:flutter/material.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';


Widget skeletonLoader() {
  return Shimmer(
    duration: const Duration(seconds: 2),
    color: AppColors.lightBlue3,
    child: Container(
      height: 110,
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBlue3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 36,
            decoration: BoxDecoration(
              color:  AppColors.lightBlue3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 150,
                  margin: const EdgeInsets.only(bottom: 12),
                  color:  AppColors.lightBlue3,
                ),
                Container(
                  height: 12,
                  width: 100,
                  color: AppColors.lightBlue3,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
