import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/text_strings.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../../../utils/helper/helper_controller.dart';
import '../models/user_model.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final showPassword = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final resetPassEmailFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    try {
      isLoading.value = true;

      // Verifica a validade do formulario
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value;
        return;
      }

      final auth = AuthenticationRepository.instance;

      // Realiza o login com e-mail e senha
      final loginResult = await auth.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Se o login falhar, mostra uma snackbar de erro
      if (!loginResult.success) {
        Helper.errorSnackBar(
          title: 'Opa',
          message: loginResult.errorMessage!,
        );
        isLoading.value = false;
        return;
      }

      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(
        title: 'Opa',
        message: e.toString(),
      );
    }
  }

  /// Realiza login usando Google
  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final auth = AuthenticationRepository.instance;

      // Realiza login usando o Google
      await auth.signInWithGoogle();
      isGoogleLoading.value = false;

      // Verifica se o usuário já existe no repositório, caso contrário, cria um novo usuário
      if (!await UserRepository.instance.recordExist(auth.getUserEmail)) {
        UserModel user = UserModel(
          id: auth.getUserID,
          email: auth.getUserEmail,
          password: '',
          fullName: auth.getDisplayName,
          phoneNo: auth.getPhoneNo,
        );
        await UserRepository.instance.createUserWithGoogle(user);
        // Get.to(const MyNavigationBar());
      }
    } catch (e) {
      isGoogleLoading.value = false;
      Helper.errorSnackBar(title: 'Opa', message: e.toString());
    }
  }

  Future<void> resetPasswordEmail() async {
    try {
      // Verifica a validade do fromulário de redefinção de senha
      if (resetPassEmailFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      isLoading.value = true;

      // Solicita um e-mail de redefinação de senha
      await AuthenticationRepository.instance.resetPasswordEmail(
        emailController.text.trim(),
      );
      // Get.to(() => OTPScreen());
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }
}
