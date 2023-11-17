import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../commom_widgets/form/form_header_widget.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/text_strings.dart';
import '../../../../commom_widgets/form/form_diviser_widget.dart';
import '../../../../commom_widgets/form/social_footer.dart';
import '../Welcome/home_page.dart';
import '../login/login_screen.dart';
import 'widgets/sign_up_form_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // SafeArea garante que o conteúdo da tela não seja coberto por barras de status, recortes, etc.
      child: Scaffold(
        // Barra superior da tela.
        appBar: AppBar(
          // Botão de voltar.
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30.0),
            onPressed: () {
              // Ao pressionar, redireciona o usuário para a tela de boas-vindas.
              Get.offAll(() => const WelcomeScreen());
            },
          ),
        ),
        // Corpo da tela.
        body: SingleChildScrollView(
          // Permite a rolagem se o conteúdo exceder a altura da tela.
          child: Container(
            // Espaçamento interno.
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Column(
              // Widgets alinhados à esquerda.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget do cabeçalho da tela de cadastro.
                const FormHeaderWidget(
                  image: moneyLogoPng,
                  title: tSignUpTitle,
                  heightBetween: 10,
                  subTitle: tSignUpSubTitle,
                  imageHeight: 0.1,
                ),
                // Widget do formulário de inscrição.
                SignUpFormWidget(),
                // Widget divisor.
                const MyFormDividerWidget(),
                // Rodapé com opções de mídia social e redirecionamento para tela de login.
                SocialFooter(
                  text1: tAlreadyHaveAnAccount,
                  text2: tLogin,
                  onPressed: () => Get.off(() => const LoginScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
