import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../core/nav_bar/navigation_bar.dart';

class SignUpController extends GetxController {
  // Obtêm uma instancia do SignUpController
  static SignUpController get instance => Get.find();

  // Instância do banco de dados Firestore.
  final _db = FirebaseFirestore.instance;

  // Observáveis para controlar a visibilidade da senha e o status de carregamento do Google e Facebook.
  final showPassword = false.obs;
  final isGoogleLoading = false.obs;
  // final isFacebookLoading = false.obs;

  // Chave para acessar e validar o formulário de registro.
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // Instâncias do Firebase Auth e Firestore para autenticação e armazenamento de dados, respectivamente.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controladores de texto para obter e definir os valores dos campos do formulário.
  final fullName = TextEditingController();
  final emailController = TextEditingController();
  final phoneNo = TextEditingController();
  final password = TextEditingController();
  // final cpf = TextEditingController();

  //* Observáveis para controlar o status de carregamento e se o usuário é um administrador.
  final isLoading = false.obs;

  //@ Registra um novo usuário utilizando authenticação via [EmailAndPassword]
  Future<void> createUser(String email) async {
    try {
      isLoading.value = true;

      // Validação do formulário
      if (!signupFormKey.currentState!.validate()) {
        isLoading.value = false;
        log('Formulário inválido');
        return;
      }

      // Verificação de e-mail duplicado
      if (await recordExist(email)) {
        throw 'O e-mail informado já possui cadastro';
      }

      // Obtenção dos dados do formulário
      String userEmail = emailController.text.trim();
      String userPassword = password.text.trim();
      String userFullName = fullName.text.trim();
      String userPhone = phoneNo.text.trim();

      // Registro do usuário no Firebase Auth
      final auth = AuthenticationRepository();
      await auth.registerWithEmailAndPassword(userEmail, userPassword);

      // Registro dos detalhes do usuário no Firestore
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).set(
        {
          'id': _auth.currentUser!.uid,
          'E-mail': userEmail,
          'Nome Completo': userFullName,
          'Numero de telefone': userPhone,
        },
      );

      // Definir a tela inicial após o registro bem-sucedido
      auth.setInitialScreen(auth.firebaseUser);

      // Redirecionamento para a tela principal
      Get.to(() => const MyNavigationBar());
    } catch (e) {
      // Tratamento de exceções
      isLoading.value = false;
      Get.snackbar(
        'Erro',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      log('Erro de registro: $e');
    }
  }

  //* Verifica se um registro do usuário já existe usando um e-mail específico
  Future<bool> recordExist(String email) async {
    try {
      // Busca no firestore um usuário com o e-mail fornecido
      final snapshot =
          await _db.collection('Users').where('E-mail', isEqualTo: email).get();

      // Retorna True se um registro existente foi encontrado
      return snapshot.docs.isEmpty ? false : true;
    } catch (e) {
      throw 'Erro ao buscar registro: $e';
    }
  }
}
