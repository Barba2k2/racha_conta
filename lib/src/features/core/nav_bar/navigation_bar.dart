import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/colors.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../expenses/expenses_page/expenses_page.dart';
import '../../authentication/controllers/nav_bar_controller.dart';
import '../profile/profile_screen.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  final List<GetPage> _pages = [
    GetPage(name: '/reporting', page: () => const ExpensesScreen()),
    GetPage(name: '/user/Settings', page: () => const ProfileScreen()),
  ];

  final controller = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return StreamBuilder<bool>(
      stream: themeController.isDarkMode.stream,
      initialData: themeController.isDarkMode.value,
      builder: (context, snapshot) {
        final isDark = snapshot.data ?? false;
        return GetBuilder<NavBarController>(
          builder: (context) {
            int selectedIndex = controller.tabIndex.clamp(0, _pages.length - 1);
            return Scaffold(
              body: IndexedStack(
                index: controller.tabIndex,
                children: _pages.map((page) => page.page()).toList(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: isDark ? darkNavBar : whiteNavBar,
                selectedItemColor: isDark ? whiteColor : blackColor,
                unselectedItemColor: isDark ? white60 : greyShade600,
                currentIndex: controller.tabIndex,
                elevation: 0,
                onTap: (index) {
                  setState(() {
                    controller.tabIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.wallet_rounded,
                      color: isDark ? whiteColor : blackColor,
                    ),
                    label: selectedIndex == 0 ? "Minhas Depesas" : "",
                    backgroundColor: isDark ? darkNavBar : whiteBgNavBar,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      LineIcons.user,
                      color: isDark ? whiteColor : blackColor,
                    ),
                    label: selectedIndex == 1 ? "Perfil" : "",
                    backgroundColor: isDark ? darkNavBar : whiteBgNavBar,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
