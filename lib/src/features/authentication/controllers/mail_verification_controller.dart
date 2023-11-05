import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/constants/text_strings.dart';
import 'package:racha_conta/src/repository/authentication_repository/authentication_repository.dart';

import '../../../utils/helper/helper_controller.dart';

class MailVerificationController extends GetxController {
  late Timer timer;
  int _attempts = 0;

  @override
  void onInit() async {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }

  void sendVerificationEmail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      Helper.successSnackBar(
        title: 'Ae sim em',
        message: 'O e-mail foi enviado com sucesso',
      );
    } catch (e) {
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  void setTimerForAutoRedirect() async {
    try {
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) async {
          try {
            await Future.delayed(const Duration(seconds: 1));
            // Recarrega as informações do usuário
            await FirebaseAuth.instance.currentUser?.reload();
          } catch (e) {
            throw ('Erro ao recarregar o usuário: %e');
          }

          final user = FirebaseAuth.instance.currentUser;

          // Se o e-mail do usuário foi verificado, cancela o timer e redireciona para a tela incial
          if (user!.emailVerified) {
            timer.cancel();
            AuthenticationRepository.instance.setInitialScreen(user);
          } else if (_attempts > 20) {
            // Após 20 tentativas, o timer é cancelado e uma mensagem é exibida ao usuário
            timer.cancel();
            Helper.errorSnackBar(
              title: "Erro",
              message: "Verifique manualmente seu e-mail",
            );
          }

          // Incrementa a contagem de tentativas
          _attempts++;
        },
      );
    } catch (e) {
      log('Erro no timer de redirecionamente: $e');
    }
  }

  void manuallyCheckEmailVerifcationStatus() async {
    try {
      try {
        await Future.delayed(const Duration(seconds: 1));
        // Recarrega as informações do usuário
        await FirebaseAuth.instance.currentUser?.reload();
      } catch (e) {
        throw ("Erro ao recarregar o usuário: $e");
      }

      final user = FirebaseAuth.instance.currentUser;

      // Se o e-mail do usuário foi verificado, redireciona para a tela inicial
      if (user!.emailVerified) {
        AuthenticationRepository.instance.setInitialScreen(user);
      } else {
        // Se não, exibe uma mensagem de erro
        Helper.errorSnackBar(
          title: "Erro",
          message: "E-mail ainda não verificado",
        );
      }
    } catch (e) {
      log("Erro na checagem de status de email: $e");
    }
  }
}
