import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../features/authentication/models/user_model.dart';

class UserService extends GetxController {
  static UserService get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('Users').add(user.toJson());
      // Mostra uma snackbar de sucesso quando a operação é bem sucedida
      Get.snackbar(
        'Parabés',
        'Sua conta foi criada.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: whiteColor,
      );
    } catch (e) {
      // Mostra uma snackbar de erro se algo der errado
      Get.snackbar(
        'Erro',
        'Algo deu errado... Tente novamente mais tarde',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.red,
      );
      log('Erro de criação de conta no service: $e');
    }
  }
}
