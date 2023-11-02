

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/widgets/expenses.dart';

import 'controllers/theme_controller/theme_controller.dart';
import 'utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    SystemChrome.setPreferredOrientations([
    //@ Força o app a ficar em apenas uma orientação
    DeviceOrientation.portraitUp,
  ]);
    return GetMaterialApp(
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const Expenses(),
    );
  }
}
