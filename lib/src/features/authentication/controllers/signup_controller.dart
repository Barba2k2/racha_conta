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
  final cpf = TextEditingController();

  //* Observáveis para controlar o status de carregamento e se o usuário é um administrador.
  final isLoading = false.obs;

  //@ Registra um novo usuário utilizando authenticação via [EmailAndPassword]
  Future<void> createUser(String email) async {
    try {
      // Verifica se o e-mail já existe no sistema
      if (await recordExist(email)) {
        throw 'O e-mail informado ja possui cadastro';
      } else {
        // Indica que o processo de registro começou
        isLoading.value = true;

        // Valida o formulário
        if (signupFormKey.currentState!.validate()) {
          isLoading.value = false;
          return;
        }

        // Intância do repositório de autenticação
        final auth = AuthenticationRepository();

        // Registra o usuário no firebase usando e-mail e senha
        await auth.registerWithEmailAndPassword(
          emailController.text.trim(),
          password.text.trim(),
        );

        // Insere os detalhes do usuário no Firestore
        await _firestore.collection('Users').doc(_auth.currentUser!.uid).set(
          {
            'id': _auth.currentUser!.uid,
            'E-mail': emailController.text.trim(),
            'Nome Completo': fullName.text.trim(),
            'Numero de telefone': phoneNo.text.trim(),
          },
        ).catchError(
          (e) => log('Erro ao criar coleção: $e'),
        );

        // Define a tela inicial após o registro bem-sucedido
        auth.setInitialScreen(auth.firebaseUser);

        // Navega até a tela principal
        Get.to(() => const MyNavigationBar());
      }
    } catch (e) {
      // Interrompe o carregamento e mostra o erro
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
      final snapshot = await _db.collection('Users').where('E-mail', isEqualTo: email).get();

      // Retorna True se um registro existente foi encontrado
      return snapshot.docs.isEmpty ? false : true;
    } catch (e) {
      throw 'Erro ao buscar registro: $e';
    }
  }
}
