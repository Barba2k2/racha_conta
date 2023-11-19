import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racha_conta/src/features/authentication/screens/login/login_screen.dart';

import '../../../../../commom_widgets/form/form_header_widget.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../controllers/theme_controller/theme_controller.dart';
import '../../../../../utils/helper/helper_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../email_has_sent/email_sent.dart';
import '../../welcome/home_page.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordMailScreen> createState() => _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  // Controlador para o campo de email
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30.0),
            onPressed: () {
              Get.to(() => const LoginScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Gap(80),
                // Cabeçalho da forma
                FormHeaderWidget(
                  image: tForgetPasswordImage,
                  imageColor: isDark ? tPrimaryColor : tSecondaryColor,
                  title: tForgetPassword,
                  subTitle: tForgetMailSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                // Formulário para inserção do e-mail
                Form(
                  key: controller.resetPassEmailFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: Helper.validateEmail,
                        decoration: const InputDecoration(
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const Gap(20),
                      // Botão de envio
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: sendResetPasswordEmail,
                          child: Text(
                            'Enviar',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método separado dos controllers por não funcionar externamente

  // Método para enviar o e-mail de redefinição de senha
  void sendResetPasswordEmail() async {
    try {
      final email = emailController.text;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      log('E-mail enviado para: $email');
      await Get.to(() => const MailSend());
    } on FirebaseAuthException catch (e) {
      Helper.errorSnackBar(title: tOps, message: e.message);
    } catch (e) {
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }
}
