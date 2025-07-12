import 'package:flutter/material.dart';

import '../untilities/app_colors.dart';
import 'text_wiget.dart';

class ButtonWiget extends StatelessWidget {
  final Color? buttonBackgroundColor;
  final Color? textColor;
  final double? radius;
  final String buttonText;
  final double buttonFontSize;
  final FontWeight? fontWeight;
  final double? buttonHeight;
  final double? buttonWidth;
  final void Function()? onPressed;
  final IconData? icon;
  const ButtonWiget(
      {super.key,
      this.buttonBackgroundColor,
      this.textColor,
      this.radius,
      required this.buttonText,
      required this.buttonFontSize,
      this.fontWeight,
      this.buttonHeight,
      this.buttonWidth,
      required this.onPressed,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            fixedSize: Size(buttonWidth ?? 350, buttonHeight ?? 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 10)),
            backgroundColor: buttonBackgroundColor ?? AppColors.blue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: AppColors.white,
              ),
              SizedBox(
                width: 5,
              )
            ],
            TextWidget(
                text: buttonText,
                textColor: textColor ?? AppColors.white,
                fontSize: buttonFontSize,
                fontWeight: fontWeight ?? FontWeight.normal),
          ],
        ));
  }
}
