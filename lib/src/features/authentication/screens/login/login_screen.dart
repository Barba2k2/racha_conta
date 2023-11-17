import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../commom_widgets/form/form_header_widget.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/text_strings.dart';
import '../../../../commom_widgets/form/form_diviser_widget.dart';
import '../../../../commom_widgets/form/social_footer.dart';
import '../sign_up/signup_screen.dart';
import '../welcome/home_page.dart';
import 'widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // AppBar com botão de retorno para a tela de boas-vindas
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30.0),
            onPressed: () {
              Get.offAll(() => const WelcomeScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho do formulário de login
                const FormHeaderWidget(
                  image: moneyLogoPng,
                  title: tLoginTitle,
                  subTitle: tLoginSubTitle,
                ),
                // Widget do formulário de login
                const LoginFormWidget(),
                // Divisor gráfico entre formulário de login e rodapé
                const MyFormDividerWidget(),
                // Rodapé com opção de registro
                SocialFooter(
                  text1: tDontHaveAnAccount,
                  text2: tSignup,
                  onPressed: () => Get.off(() => const SignupScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
