import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/constants/colors.dart';

import '../../controllers/theme_controller/theme_controller.dart';

class MyFormDividerWidget extends StatelessWidget {
  const MyFormDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    return Row(
      children: [
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 30,
            color: Colors.grey.withOpacity(0.3),
            endIndent: 10,
          ),
        ),
        Text(
          'OU',
          style: Theme.of(context).textTheme.bodyLarge!.apply(
                color: isDark
                    ? tWhiteColor.withOpacity(0.5)
                    : tDarkColor.withOpacity(0.5),
              ),
        ),
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey.withOpacity(0.3),
            endIndent: 30,
          ),
        ),
      ],
    );
  }
}
