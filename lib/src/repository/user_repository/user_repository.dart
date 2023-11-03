import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/authentication/models/user_model.dart';
import '../authentication_repository/exceptions/exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createUser(UserModel user) async {
    try {
      if (await recordExist(user.email)) {
        throw 'O e-mail ${user.email} já possui cadastro';
      } else {
        DocumentReference docRef =
            await _db.collection('Users').add(user.toJson());
        //# Retorna o id do documento criado
        log('Docuemnto do usuário: ${docRef.id}');
        return docRef.id;
      }
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente!'
          : e.toString();
    }
  }

  //% Verifica se o usuário existe com e email ou telefone informado
  Future<bool> recordExist(String email) async {
    try {
      final snapshot =
          await _db.collection("Users").where("E-mail", isEqualTo: email).get();
      return snapshot.docs.isEmpty ? false : true;
    } catch (e) {
      throw "Erro ao buscar registro: $e";
    }
  }
}
