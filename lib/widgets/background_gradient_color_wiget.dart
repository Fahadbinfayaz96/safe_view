import 'package:flutter/material.dart';

import '../untilities/app_colors.dart';

class BackgroundGradientColorWiget extends StatelessWidget {
  final Widget? child;
  final double? padding;

  const BackgroundGradientColorWiget(
      {super.key,  this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightBlue2,
            AppColors.lightBlue1.withOpacity(.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
