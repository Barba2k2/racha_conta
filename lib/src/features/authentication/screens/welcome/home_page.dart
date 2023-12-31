import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/text_strings.dart';
import '../../../../controllers/theme_controller/theme_controller.dart';
import '../login/login_screen.dart';
import '../sign_up/signup_screen.dart';

// Definição da tela de boas-vindas.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Obtém o controle do tema para verificar se está no modo escuro.
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    // Construção da tela.
    return SafeArea(
      child: Scaffold(
        // Define a cor de fundo com base no modo escuro ou claro.
        backgroundColor: isDark ? tDarkColor : tWhiteColor,
        body: Column(
          children: [
            const Gap(100),
            // Imagem de boas-vindas.
            const SizedBox(
              height: 300,
              child: Image(
                image: AssetImage(moneyLogoPng),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // Centraliza os elementos na tela.
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Botão de login.
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.to(() => const LoginScreen()),
                        child: Text(
                          tLogin.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: purple),
                        ),
                      ),
                    ),
                    const Gap(10),
                    // Botão de inscrição.
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const SignupScreen()),
                        child: Text(
                          tSignup.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: whiteColor),
                        ),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
