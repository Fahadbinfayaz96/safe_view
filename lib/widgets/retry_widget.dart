import 'package:flutter/material.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/text_wiget.dart' show TextWidget;

import '../untilities/app_colors.dart';

retryWidget(
    {required void Function() onPress,
    required String errorMessage,
    bool isError = true}) {
  return BackgroundGradientColorWiget(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: errorMessage,
            textColor: isError? AppColors.red:AppColors.charcoalGrey,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: onPress,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh,
                  color: AppColors.blue,
                ),
                const SizedBox(
                  width: 5,
                ),
                TextWidget(
                  text: "Retry",
                  textColor: AppColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
