import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:racha_conta/src/constants/colors.dart';

import '../../../commom_widgets/buttons/primary_button.dart';
import '../../../constants/text_strings.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../expenses/controllers/user_controller.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../authentication/models/user_model.dart';
import '../../authentication/screens/welcome/home_page.dart';
import 'update_profile_screen.dart';
import 'widgets/image_with_icon.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final ThemeController themeController = Get.find();

    return Obx(
      () {
        final isDark = themeController.isDarkMode.value;

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                profile,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              actions: [
                IconButton(
                  onPressed: themeController.toggleTheme,
                  icon: Icon(
                    isDark ? LineAwesomeIcons.moon : LineAwesomeIcons.sun,
                  ),
                  iconSize: 26,
                )
              ],
            ),
            backgroundColor: isDark ? darkNavBar : whiteNavBar,
            body: SingleChildScrollView(
              child: Container(
                color: isDark ? darkNavBar : whiteNavBar,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// -- IMAGE with ICON
                    const ImageWithIcon(),
                    const Gap(10),
                    StreamBuilder<UserModel?>(
                      stream: userController.userStream,
                      builder: (context, snapshot) {
                        UserModel? user = snapshot.data;
                        return Column(
                          children: [
                            Text(
                              user?.fullName ?? 'Fulano de Tal',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: isDark ? whiteColor : blackColor,
                                  ),
                            ),
                            Text(
                              user?.email ?? 'email@email.com',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        );
                      },
                    ),
                    const Gap(20),

                    /// -- BUTTON
                    MyPrimaryButton(
                      isFullWidth: false,
                      width: 240,
                      text: editProfile,
                      onPressed: () {
                        //* Proxima Feature
                        Get.to(() => UpdateProfileScreen());
                      },
                    ),
                    const Gap(30),
                    const Divider(),
                    const Gap(10),

                    /// -- MENU
                    ProfileMenuWidget(
                      title: "Configurações",
                      icon: LineAwesomeIcons.cog,
                      onPress: () {},
                    ),
                    ProfileMenuWidget(
                      title: "Informações",
                      icon: LineAwesomeIcons.info,
                      onPress: () {},
                    ),
                    ProfileMenuWidget(
                      title: "Sair",
                      icon: LineAwesomeIcons.alternate_sign_out,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () => _showLogoutModal(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showLogoutModal() {
    Get.defaultDialog(
      title: "SAIR",
      titleStyle: const TextStyle(fontSize: 20),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text("Tem certeza que gostaria\n de sair do aplicativo?"),
      ),
      confirm: MyPrimaryButton(
        isFullWidth: false,
        onPressed: () {
          Get.offAll(() => const WelcomeScreen());
          AuthenticationRepository.instance.logout();
        },
        text: "Sim",
      ),
      cancel: SizedBox(
        width: 100,
        child: OutlinedButton(
          onPressed: () => Get.back(),
          child: const Text("Não"),
        ),
      ),
    );
  }
}
