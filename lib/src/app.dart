

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controllers/theme_controller/theme_controller.dart';
import 'expenses/expenses_page/expenses.dart';
import 'utils/app_bindings.dart';
import 'utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    SystemChrome.setPreferredOrientations([
    //@ Força o app a ficar em apenas uma orientação
    DeviceOrientation.portraitUp,
  ],);

    return GetMaterialApp(
      initialBinding: InitialBinding(),
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const Expenses(),
    );
  }
}
