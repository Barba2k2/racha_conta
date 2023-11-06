import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../expenses/expenses_page/expenses.dart';
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
    // setInitialScreen(_firebaseUser.value);
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
    // user == null ? Get.offAll(() => WelcomeScreen()) : Get.offAll(() => const Expenses());
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

      // Redirecionar para Expanses após o login bem sucedido
      Get.to(() => const Expenses());

      // Uma vez conectado, retorne o UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Erro do Firestore na criação de usuário com Google: $e');
      final ex = MyExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      const ex = MyExceptions();
      throw ex.message;
    }
  }

  Future<void> resetPasswordEmail(String email) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      await auth
          .sendPasswordResetEmail(email: email)
          .then((value) => log('Email enviado'));
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
}
