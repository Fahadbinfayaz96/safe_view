import 'package:flutter/material.dart';

import '../untilities/app_colors.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  FontWeight? fontWeight;
  TextOverflow? textOverflow;
  int? maxLines;
  TextAlign? textAlignment;
  final double? letterSpacing;
  TextWidget(
      {super.key,
      required this.text,
      this.textColor,
      this.fontSize,
      this.fontWeight,
      this.textOverflow,
      this.maxLines,
      this.textAlignment,
      this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: textColor ?? AppColors.black,
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          decoration: TextDecoration.none),
      maxLines: maxLines ?? 5,
      textAlign: textAlignment,
      overflow: textOverflow ?? TextOverflow.clip,
    );
  }
}
