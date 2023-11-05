import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/commom_widgets/buttons/social_button.dart';
import 'package:racha_conta/src/constants/colors.dart';

import '../../constants/image_strings.dart';
import '../../constants/text_strings.dart';
import '../../features/authentication/controllers/login_controller.dart';
import '../buttons/clickable_richtext_widget.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter(
    this.onPressed, {
    this.text1 = 'Ainda não possui uma conta?',
    this.text2 = 'Cadastre-se',
    super.key,
  });

  final String text1;
  final String text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Obx(
            () => SocialButton(
              image: googleLogo,
              background: tGoogleBgColor,
              foreground: tGoogleForegroundColor,
              text: '${tConnectWith.tr} ${tGoogle.tr}',
              isLoading: controller.isGoogleLoading.value,
              onPressed: controller.isLoading.value ? () {} : controller.isGoogleLoading.value ? (){} : () => controller.googleSignIn(),
            ),
          ),
          const Gap(20),
          // Texto clicável para direcionar o usuário a outra página (como cadastro).
          ClickableRichTextWidget(
            text1: text1.tr,
            text2: text2.tr,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
