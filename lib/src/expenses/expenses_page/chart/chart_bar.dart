import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/constants/colors.dart';

import '../../../controllers/theme_controller/theme_controller.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({super.key, required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: FractionallySizedBox(
          heightFactor: fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              color: isDark ? blackColor : whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
