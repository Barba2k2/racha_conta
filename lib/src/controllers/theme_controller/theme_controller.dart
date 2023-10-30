import 'package:get/get.dart';
import '../../utils/theme/theme.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  // Getter para obter o valor de isDarkMode
  bool get currentTheme => isDarkMode.value;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(
      isDarkMode.value ? MyAppTheme.darkTheme : MyAppTheme.lightTheme,
    );
  }
}
