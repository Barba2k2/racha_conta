import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/authentication/models/user_model.dart';
import '../../features/authentication/screens/update_or_register/update_or_register_screen.dart';
import '../../features/authentication/screens/welcome/home_page.dart';
import '../../features/core/nav_bar/navigation_bar.dart';
import '../../utils/helper/helper_controller.dart';
import 'exceptions/exceptions.dart';
import 'result/login_result.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //* Variaveis
  Rx<User?> _firebaseUser = Rx<User?>(null);
  final _auth = FirebaseAuth.instance;
  final phoneVerificationId = ''.obs;
  final firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
    super.onReady();
  }

  //@ Getters
  User? get firebaseUser => _firebaseUser.value;
  String get getUserID => firebaseUser?.uid ?? '';
  String get getUserEmail => firebaseUser?.email ?? '';
  String get getDisplayName => firebaseUser?.displayName ?? '';
  String get getPhoneNo => firebaseUser?.phoneNumber ?? '';

  //! Verifica se o usuário está logado ou não
  setInitialScreen(User? user) async {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => const MyNavigationBar());
  }

  // Verifica se o login falhou devido a credenciais inválidas
  bool isInvalidCredentialsError(FirebaseAuthException e) {
    // O código de erro 'user-not-found' indica que o e-mail não foi encontrado
    // O código de erro 'wrong-password' indica que a senha está incorreta
    return e.code == 'user-not-found' || e.code == 'wrong-password';
  }

  /// [EmailAuthentication] - LOGIN
  Future<MyLoginResult> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return MyLoginResult.success();
    } on FirebaseAuthException catch (e) {
      if (isInvalidCredentialsError(e)) {
        return MyLoginResult.failure(
          'Verifique o e-mail ou a senha e tente novamente',
        );
      } else {
        final result = MyExceptions.fromCode(e.code);
        throw result.message;
      }
    } catch (e) {
      log('Erro ao efeutuar o login com e-mail: $e');
      const result = MyExceptions();
      throw result.message;
    }
  }

  /// [EmailAuthentication] - REGISTRO
  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log('Erro do FirebaseAuth: $e');
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro ao registrar usuário: $e');
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  /// [EmailVerification] - VERIFICAÇÃO DE E-MAIL
  Future<void> sendEmailVerification() async {
    try {
      // Verificando o status do usuário antes de enviar o e-mail
      if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
        await _auth.currentUser?.sendEmailVerification();
      } else {
        throw const MyExceptions();
      }
    } on FirebaseAuthException catch (e) {
      log('Erro do FirebaseAuth: $e');
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro ao enviar e-mail de verificação: $e');
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  //* ---------------------------- LOGIN Social --------------------------------- *//

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Aciona a autenticação do Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //* Obtem detalhes da requisição
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      //@ Cria uma nova credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      log('Credencias: $credential');

      // Redirecionar para Expanses após o login bem sucedido
      Get.to(() => const MyNavigationBar());

      // Uma vez conectado, retorne o UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e, stackTrace) {
      log(
        'Erro do Firestore na criação de usuário com Google: ${e.code}, ${e.message}, $stackTrace',
      );
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro no Auth Repo: $e');
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  Future<void> resetPasswordEmail(String email) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      await auth.sendPasswordResetEmail(email: email).then(
            (value) => log('Email enviado'),
          );
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } catch (e) {
      log('Erro ao enviar email de recuperção de senha: $e');
      const result = MyExceptions();
      throw result.message;
    }
  }

  //? Desloga o usuário do app
  /// [LogoutUser] - Valido para qualquer autenticação
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      // Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      log('Erro do Firerbase Auth no logout: $e');
      throw e.message!;
    } on FormatException catch (e) {
      log('erro do format exception: $e');
      throw e.message;
    } catch (e) {
      log('Erro ao deslogar usuário: $e');
      throw 'Não foi possível sair. Tente novamente mais tarde';
    }
  }

  /// [PhoneAuthentication] - LOGIN
  /*loginWithPhoneNo(String phoneNumber) async {
    try {
      await _auth.signInWithPhoneNumber(phoneNumber);
    } on FirebaseAuthException catch (e) {
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Um erro desconhecido ocorreu. Tente novamente!'
          : e.toString();
    }
  }*/

  /// [PhoneAuthentication] - REGISTRO
  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      //Verifica se o número de telefone ja está associado a uma conta.
      final isRegistered = await isPhoneNumberRegistered(phoneNo);
      log('Está registrado: $isRegistered');

      if (isRegistered) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          verificationCompleted: (credential) async {
            await _auth.signInWithCredential(credential);
          },
          codeSent: (verificationId, resendToken) {
            phoneVerificationId.value = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            phoneVerificationId.value = verificationId;
          },
          verificationFailed: (e) {
            log('Erro de verificação: $e');
            final result = MyExceptions.fromCode(e.code);
            throw result.message;
          },
        );
      } else {
        /// Se não estiver associado, exibe uma tela informando ao usuário
        /// para atualizar os dados ou criar uma conta.
        Get.to(() => const UpdateOrRegisterScreen());
      }
    } on FirebaseAuthException catch (e) {
      log('Erro do Firebase Auth Execeptions: $e');
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } catch (e) {
      log('Erro: $e');
      throw e.toString().isEmpty
          ? 'Um erro desconhecido ocorreu. Tente novamente!'
          : e.toString();
    }
  }

  Future<bool> isPhoneNumberRegistered(String phoneNo) async {
    try {
      // Buscar o número de telefone na coleção 'Users'
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Numero de Telefone', isEqualTo: phoneNo)
          .get();

      // Se encontrarmos algum documento com esse número de telefone, retornamos verdadeiro
      if (querySnapshot.docs.isNotEmpty) {
        final UserModel user = UserModel.fromSnapshot(querySnapshot.docs.first);
        // Aqui você pode logar ou fazer qualquer coisa com o usuário, se necessário.
        log('User Found: ${user.phoneNo}');
        return true;
      }

      return false;
    } on FirebaseException catch (e) {
      log('Erro da Firestore: $e');
      throw 'Erro da Firestore: $e';
    } catch (e) {
      log("Erro ao verificar o número de telefone: $e");
      return false;
    }
  }

  /// [PhoneAuthentication] - VERIFICA O NUMERO DE TELEFONE VIA OTP
  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: phoneVerificationId.value,
        smsCode: otp,
      ),
    );
    return credentials.user != null ? true : false;
  }

  /// Updates the user's password
  Future<void> resetPasswordWithOTP(
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      // Validação das senhas
      if (newPassword != confirmPassword) {
        throw const MyExceptions('As senhas não coincidem.');
      }
      if (newPassword.length < 8) {
        Helper.validatePassword(newPassword);
      }

      // Atualizar a senha
      if (_firebaseUser.value != null) {
        await _firebaseUser.value!.updatePassword(newPassword);
      } else {
        throw const MyExceptions('Erro ao atualizar a senha.');
      }
    } on FirebaseAuthException catch (e) {
      log('Erro do FirebaseAuthException: $e');
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      log('Erro na redefinição de senha: $e');
      throw e.toString();
    }
  }
}
