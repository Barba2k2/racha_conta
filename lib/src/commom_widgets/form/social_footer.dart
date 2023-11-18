import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/image_strings.dart';
import '../../constants/text_strings.dart';
import '../../features/authentication/controllers/login_controller.dart';
import '../buttons/clickable_richtext_widget.dart';
import '../buttons/social_button.dart';


// Widget que representa o rodapé contendo os botões de login social e um texto clicável.
class SocialFooter extends StatelessWidget {
  // Texto padrão à esquerda do texto clicável.
  final String text1;

  // Texto clicável.
  final String text2;

  // Função a ser executada ao clicar no texto clicável.
  final VoidCallback onPressed;

  const SocialFooter({
    Key? key,
    this.text1 = tDontHaveAnAccount,
    this.text2 = tSignup,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicialização do controller.
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          // Botão de login com Google.
          Obx(
            () => SocialButton(
              // Logo do Google.
              image: googleLogo,
              // Cor de fundo do botão do Google.
              background: tGoogleBgColor,
              // Cor do texto do botão do Google.
              foreground: tGoogleForegroundColor,
              // Texto do botão do Google.
              text: '${tConnectWith.tr} ${tGoogle.tr}',
              // Se verdadeiro, mostra um indicador de carregamento.
              isLoading: controller.isGoogleLoading.value,
              // Define a ação do botão quando pressionado.
              onPressed:
                  controller.isLoading.value ?
                  () {} : controller.isGoogleLoading.value ?
                  () {} : () => controller.googleSignIn(),
            ),
          ),
          const Gap(20),
          // Texto clicável para direcionar o usuário a página de cadastro.
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